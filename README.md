# ddistro
A user-friendly Bash wrapper around the dd command, designed to make writing GNU/Linux ISO distributions to USB drives safe and easy. 

  Usage
# Features

USB Drive Detection: Automatically detects connected USB drives and displays their details (device name, size, mount point, and model).

ISO File Selection: Lists all .iso files in the current directory and allows the user to select one.

Safe Unmounting: If the selected USB drive is mounted, the script will unmount it before writing the ISO file.

Data Overwrite Warning: Provides a clear warning before overwriting data on the USB drive.

Checksum Verification: Optionally verifies the integrity of the written data by comparing checksums of the ISO file and the USB drive.
