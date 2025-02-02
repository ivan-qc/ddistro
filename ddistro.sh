#!/bin/bash

# ddistro Script
# Version: 0.1.0-beta
# WARNING: This is a beta version. Use at your own risk.

# Check for required commands
REQUIRED_COMMANDS=("dd" "lsblk" "sudo")
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v "$cmd" >/dev/null; then
        echo "Error: '$cmd' is required but not installed."
        exit 1
    fi
done

echo "WARNING: Ensure you have verified the integrity of the ISO file before proceeding."
echo "You can use tools like 'sha256sum' or 'md5sum' to compare with the official checksum."
read -p "Continue? (y/N): " CONFIRM
if [[ "${CONFIRM,,}" != "y" ]]; then
    echo "Cancelled."
    exit 0
fi

# Function to detect USB drives
detect_usb_drives() {
    echo "Detecting USB drives..."
    USB_DRIVES=()

    while read -r line; do
        # Extract device name
        DEVICE="${line%% *}"

        # Get the size of the parent device
        SIZE=$(lsblk -o SIZE -n "/dev/$DEVICE" 2>/dev/null | head -n 1)

        # Get the device model
        MODEL=$(cat "/sys/class/block/$DEVICE/device/model" 2>/dev/null)

        # Check if the device is a USB drive
        if [[ "$(readlink -f /sys/class/block/$DEVICE/device)" == *usb* ]]; then
            # Skip partitions (e.g., sdb1, sdb2) and only show parent devices (e.g., sdb)
            if [[ "$DEVICE" =~ ^(sd|mmc)[a-z]$ ]]; then
                USB_DRIVES+=("$DEVICE" "$SIZE" "$MODEL")
            fi
        fi
    done < <(lsblk -o NAME -l -n | grep -E '^(sd|mmc)[a-z]')

    if [ ${#USB_DRIVES[@]} -eq 0 ]; then
        echo "No USB drives detected."
        return 1
    fi

    echo "Detected USB drives:"

    for ((i = 0; i < ${#USB_DRIVES[@]}; i += 3)); do
        DEVICE="${USB_DRIVES[$i]}"
        SIZE="${USB_DRIVES[$i+1]}"
        MODEL="${USB_DRIVES[$i+2]}"
        echo "$((i / 3 + 1)). /dev/$DEVICE ($SIZE, ${MODEL:-Unknown})"
    done
}

# Function to select a USB drive
select_usb_drive() {
    detect_usb_drives || exit 1

    read -p "Select a USB drive by number (or 0 to cancel): " CHOICE

    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a number."
        exit 1
    fi

    if [[ "$CHOICE" -eq 0 ]]; then
        echo "Cancelled."
        exit 0
    fi

    INDEX=$(( (CHOICE - 1) * 3 ))  # Corrected to 3 for each device
    if [[ "$INDEX" -lt 0 || "$INDEX" -ge ${#USB_DRIVES[@]} ]]; then
        echo "Invalid selection."
        exit 1
    fi

    SELECTED_DEVICE="/dev/${USB_DRIVES[$INDEX]}"

    # Check if the parent device or any partition is mounted
    SELECTED_MOUNT=$(lsblk -no MOUNTPOINTS "$SELECTED_DEVICE"*)  # Check both parent and partitions

    if [[ -n "$SELECTED_MOUNT" ]]; then
        # If any partition or the device itself is mounted, get the first mount point
        SELECTED_MOUNT=$(echo "$SELECTED_MOUNT" | grep -v '^$' | head -n 1)
        echo "$SELECTED_DEVICE is mounted at $SELECTED_MOUNT."
        echo "WARNING: It will be unmounted before writing the ISO."
        read -p "Continue? (y/N): " CONFIRM
        if [[ "${CONFIRM,,}" != "y" ]]; then
            echo "Cancelled."
            exit 0
        fi
        # Unmount the USB drive and check if it was successful
        unmount_usb_drive "$SELECTED_DEVICE"
    else
        echo "$SELECTED_DEVICE can be used."
    fi
    # Now that we've confirmed the device can be used, set the destination
    DESTINATION="$SELECTED_DEVICE"
}

# Function to unmount all partitions of a selected USB drive
unmount_usb_drive() {
    local device="$1"

    # Loop through the partitions of the device
    for PARTITION in $(lsblk -o NAME -n -l "$device" | grep -E "^${device##*/}p?[0-9]+"); do
        # Get the mount point of the partition
        MOUNT_POINT=$(lsblk -o NAME,MOUNTPOINT | grep -w "$PARTITION" | cut -d ' ' -f 2)

        if [[ -n "$MOUNT_POINT" ]]; then
            # Unmount the partition if it's mounted
            echo "Unmounting /dev/$PARTITION mounted at $MOUNT_POINT..."
            if ! sudo umount "/dev/$PARTITION" 2>/dev/null; then
                echo "Error: Failed to unmount /dev/$PARTITION. Please close any open files and try again."
                exit 1
            fi
        fi
    done

    echo -e "All partitions unmounted successfully.\n$SELECTED_DEVICE can be used now."
}

# Function to list ISO files in the current directory
list_iso_files() {
    echo "Listing ISO files in the current directory..."
    ISO_FILES=()

    while read -r file; do
        ISO_FILES+=("$file")
    done < <(find . -maxdepth 1 -type f -name "*.iso" -printf "%f\n")

    if [ ${#ISO_FILES[@]} -eq 0 ]; then
        echo "No ISO files found in the current directory."
        return 1
    fi

    echo "Available ISO files:"
    for ((i = 0; i < ${#ISO_FILES[@]}; i++)); do
        echo "$((i + 1)). ${ISO_FILES[$i]}"
    done
}

# Function to select an ISO file
select_iso_file() {
    list_iso_files || exit 1

    read -p "Select an ISO file by number (or 0 to cancel): " CHOICE
    # Check if input is a valid number
    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a number."
        exit 1
    fi


    if [[ "$CHOICE" -eq 0 ]]; then
        echo "Cancelled."
        exit 0
    fi

    INDEX=$((CHOICE - 1))
    if [[ "$INDEX" -lt 0 || "$INDEX" -ge ${#ISO_FILES[@]} ]]; then
        echo "Invalid selection. Please choose a number between 1 and ${#ISO_FILES[@]}."
        exit 1
    fi

    SELECTED_ISO="${ISO_FILES[$INDEX]}"
    echo "Selected ISO file: $SELECTED_ISO"
}

# Main script
select_iso_file
select_usb_drive

# Confirm before writing
echo "WARNING: This will overwrite all data on $DESTINATION with the ISO file '$SELECTED_ISO'."
read -p "Are you sure you want to proceed? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Cancelled."
    exit 0
fi

# Write ISO to USB drive
echo "Writing '$SELECTED_ISO' to '$DESTINATION'..."
sudo dd if="$SELECTED_ISO" of="$DESTINATION" bs=4M status=progress conv=fsync

echo "Done! USB drive '$DESTINATION' is ready."
