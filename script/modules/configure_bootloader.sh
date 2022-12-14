# Configure the bootloader. Flags 2011.
# $1 = device
configure_bootloader()
{
	echo -n " Configuring bootloader..."

	if [[ "$1" == "nvme*" ]]; then
		devLvm="/dev/${1}p2"
	else
		devLvm="/dev/${1}2"
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

	flag 2011
}
