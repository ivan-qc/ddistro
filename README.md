# ddistro
A user-friendly Bash wrapper around the dd command, designed to make writing GNU/Linux ISO distributions to USB drives safe and easy. 

# Usage
    # ./ddistro.sh

# Features
Friendly Reminder: Encourages the user to verify the checksum of the ISO file before proceeding.

    WARNING: Ensure you have verified the integrity of the ISO file before proceeding.
    You can use tools like 'sha256sum' or 'md5sum' to compare with the official checksum.
    Continue? (y/N): 
    
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

    /dev/sdb is mounted at /run/media/dell/91b481cb-a96d-48d1-b7ba-dff840a41a50.
    WARNING: It will be unmounted before writing the ISO.
    Continue? (y/N): 

Data Overwrite Warning: Provides a clear warning before overwriting data on the USB drive.

    /dev/sdb can be used.
    WARNING: This will overwrite all data on /dev/sdb with the ISO file 'archlinux-x86_64.iso'.
    Are you sure you want to proceed? (y/N): 

Data Write: The progress is updated in real-time as data is written..

    Writing 'S15Pup64-22.12-241201.iso' to '/dev/sdb'...
    322961408 bytes (323 MB, 308 MiB) copied, 3 s, 107 MB/s434110464 bytes (434 MB, 414 MiB) copied, 3.46808 s, 125 MB/s
    103+1 records in
    103+1 records out
    434110464 bytes (434 MB, 414 MiB) copied, 49.9116 s, 8.7 MB/s
    Done! USB drive '/dev/sdb' is ready.
