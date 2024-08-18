source setup.conf
source modules/common/flag.sh

# Configure bootloader. Flags 3013 to signal ready to receive device from
# primary, 3014 when done.
configure_bootloader()
{
	# Get the device from the controller.
	flag 3013
	read -r -p " Awaiting device from controller... " device

	echo -n " Configuring bootloader..."

	if [[ "$device" == "nvme*" ]]; then
		devLvm="/dev/${device}p2"
	else
		devLvm="/dev/${device}2"
	fi

	uuid=$(blkid "$devLvm" | cut -d '"' -f 2)
	bootctl --path=/boot install &>/dev/null

	# Write to /boot/loader/loader.conf.
	echo "default arch" > /boot/loader/loader.conf
	echo "timeout 3"   >> /boot/loader/loader.conf
	echo "editor 0"    >> /boot/loader/loader.conf

	# Write to /boot/loader/entries/arch.conf
	echo "title Arch Linux"             > /boot/loader/entries/arch.conf
	echo "linux /vmlinuz-linux"        >> /boot/loader/entries/arch.conf
	echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
	echo "options cryptdevice=UUID=\"${uuid}\":lvm root=/dev/mapper/vg0-root quiet rw" >> /boot/loader/entries/arch.conf
	echo " done."

	flag 3014
}
