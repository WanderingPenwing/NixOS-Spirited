echo -n "Do you want to mount (m) / unmount (u) ? "
read mode

if [ "$mode" = "m" ]; then
	echo "-----------"
	sudo fdisk -l | grep -A9999 "Device     Boot Start      End  Sectors  Size Id Type"
	echo -en "\nChoose device to mount (sd..) : "
	read device

	if [ -z "$device" ]; then
        echo "Aborting..."
        exit 1
    fi
	sudo umount /media/usb-drive > /dev/null 2>&1
	sudo mount "/dev/$device" "/media/usb-drive/"
	mount | grep $device
else
	sudo umount /media/usb-drive
	echo "unmounted device"
fi

