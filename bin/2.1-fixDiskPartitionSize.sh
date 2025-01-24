#!/bin/bash
if [[ $EUID > 0 ]]; then
  echo "Please run as root"
  exit
fi

echo
echo "Fixing sda5 disk size"
echo
echo "Initial configuration"
echo

fdisk -l

echo "Moving secondary GPT header to end of disk"

sgdisk -e /dev/sda
partprobe

echo
echo "Resizing sda5 to the allocated size (type 'Yes' to confirm)"
echo

sudo parted /dev/sda resizepart 5 100%

echo
echo "Growing filesystem to match allocation"
echo

sudo xfs_growfs /dev/sda5

echo
echo "Modified configuration"
echo

fdisk -l

echo
echo "Done"
echo
