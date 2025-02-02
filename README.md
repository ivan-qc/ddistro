# ddistro (v0.1.0-beta)
A user-friendly Bash wrapper for the `dd` command-line tool, designed to simplify and streamline writing GNU/Linux ISO files to USB drives. 
It makes the process quicker, safer, and more accessible, especially for newcomers.

`ddistro` requires the following commands to be installed:

1. `dd` — Writes the ISO file to the USB drive.
2. `lsblk` — Lists available storage devices.
3. `sudo` — Required for unmounting and writing the ISO (you’ll be prompted when needed).

# Status: Beta
This project is currently in **beta**. It is functional and has been tested, but there may still be bugs or missing features. Use it at your own risk, and please report any issues you encounter.

# Usage
Run the script in the same directory where your .iso files are located.
    
    $ ./ddistro.sh

# Features
**Friendly Reminder:** Encourages the user to verify the checksum of the ISO file before proceeding.

    WARNING: Ensure you have verified the integrity of the ISO file before proceeding.
    You can use tools like 'sha256sum' or 'md5sum' to compare with the official checksum.
    Continue? (y/N): 
    
**ISO File Selection:** Lists all .iso files in the current directory and allows the user to select one.

    Listing ISO files in the current directory...
    Available ISO files:
    1. archlinux-x86_64.iso
    2. debian-12.7.0-amd64-DVD-1.iso
    3. openSUSE-Tumbleweed-DVD-x86_64-Snapshot20250130-Media.iso
    4. minix-3.1.0-book.iso
    5. FreeBSD-14.2-RELEASE-amd64-dvd1.iso
    6. fossapup64-9.5.iso
    7. slackware64-15.0-install-dvd.iso
    Select an ISO file by number (or 0 to cancel):

**USB Drive Detection:** Automatically detects connected USB drives and displays their details (device name, size, and model).

    Detecting USB drives...
    Detected USB drives:
    1. /dev/sdb (14.4G, DataTraveler 3.0)
    2. /dev/sdc (29.8G, SanDisk Ultra)
    Select a USB drive by number (or 0 to cancel):

**Safe Unmounting:** If the selected USB drive is mounted, the script will unmount it before writing the ISO file.

    /dev/sdb is mounted at /run/media/archie/91b481cb-a96d-48d1-b7ba-dff840a41a50.
    WARNING: It will be unmounted before writing the ISO.
    Continue? (y/N): 

**Data Overwrite Warning:** Provides a clear warning before overwriting data on the USB drive.

    /dev/sdb can be used.
    WARNING: This will overwrite all data on /dev/sdb with the ISO file 'archlinux-x86_64.iso'.
    Are you sure you want to proceed? (y/N): 

**Real-Time Progress:** Updates occur instantly as data is written.

    Writing 'archlinux-x86_64.iso' to '/dev/sdb'...
    1231060992 bytes (1.2 GB, 1.1 GiB) copied, 44 s, 27.9 MB/s
    293+1 records in
    293+1 records out
    1231060992 bytes (1.2 GB, 1.1 GiB) copied, 138.298 s, 8.9 MB/s
    Done! USB drive '/dev/sdb' is ready.

# Contributing
If you'd like to contribute or report a bug, please open an issue or submit a pull request.
