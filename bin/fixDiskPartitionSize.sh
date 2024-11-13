#!/bin/bash

echo
echo "Fixing sda5 disk size"
echo
echo "Initial configuration"
echo

fdisk -l

echo "Moving secondary GPT header to end of disk"

sgdisk -e /dev/sda

