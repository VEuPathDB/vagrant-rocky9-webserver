#!/bin/bash

echo
echo "Fixing sda5 disk size"
echo
echo "Initial configuration"
echo

fdisk -l

echo "Moving secondary GPT header to end of disk"

sgdisk -e /dev/sda
partprobe

echo "Resizing sda5 to the allocated size (type 'Yes' to confirm)"

sudo parted /dev/sdb resizepart 5 100%

echo "Growing filesystem to match allocation"

sudo xfs_growfs /dev/sda5

echo "Done"
