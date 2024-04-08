#!/usr/bin/env bash

if mount | grep -q "/media/usb-drive"; then
	device=$(mount | grep "/media/usb-drive" | awk '{print $1}')
	unmount=$(echo -e "yes\nno" | dmenu -p "unmount $device : " -fn 'Hack Regular-16' -nb "#222222" -nf "#CCCCCC" -sb "#3FB36D" -sf "#FFFFFF") 
	
	if [ "$unmount" = "yes" ]; then
		result=$(~/nixos/scripts/dmenu_sudo.sh umount /media/usb-drive)
		if [ "$result" = "success" ]; then
			notify-send -u normal -a "guest" "unmounted device"
		fi
	fi
else
	device_name=$(lsblk --noheading --paths --raw --output NAME,RM,TRAN,TYPE | grep part | grep -v nvme | awk 'BEGIN{print "cancel"} {print $1}' | dmenu -p "mount : " -fn 'Hack Regular-16' -nb "#222222" -nf "#CCCCCC" -sb "#3FB36D" -sf "#FFFFFF") 

	if [ "$device_name" = "cancel" ]; then
        exit 1
    fi
	
    device=$(echo "$device_name" | awk '{print $1$2}')
    
	~/nixos/scripts/dmenu_sudo.sh mount "$device" "/media/usb-drive/"
	notify-send -u normal -a "guest" "mounted $device to /media/usb-drive/"
fi

