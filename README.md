# ddistro
A user-friendly Bash wrapper around the dd command, designed to make writing GNU/Linux ISO distributions to USB drives safe and easy. 

# Usage
    # ./ddistro.sh

# Features
ISO File Selection: Lists all .iso files in the current directory and allows the user to select one.

    Listing ISO files in the current directory...
    Available ISO files:
    1. archlinux-x86_64.iso
    2. debian-12.7.0-amd64-DVD-1.iso
    3. minix-3.1.0-book.iso
    4. FreeBSD-14.2-RELEASE-amd64-dvd1.iso
    5. fossapup64-9.5.iso
    6. S15Pup64-22.12-241201.iso
    7. slackware64-15.0-install-dvd.iso
    Select an ISO file by number (or 0 to cancel):

USB Drive Detection: Automatically detects connected USB drives and displays their details (device name, size, mount point, and model).

    Detecting USB drives...
    Detected USB drives:
    1. /dev/sdb (3.0, DataTraveler_3.0) []
    Select a USB drive by number (or 0 to cancel):

Safe Unmounting: If the selected USB drive is mounted, the script will unmount it before writing the ISO file.

Data Overwrite Warning: Provides a clear warning before overwriting data on the USB drive.

Checksum Verification: Optionally verifies the integrity of the written data by comparing checksums of the ISO file and the USB drive.
