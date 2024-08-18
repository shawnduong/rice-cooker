source setup.conf
source modules/common/flag.sh

# Make initial ramdisk with mkinitcpio. Flags 3012.
generate_ramdisk()
{
	# Update mkinitcpio hooks.
	echo -n " Creating initial ramdisk..."
	cat /etc/mkinitcpio.conf | sed -e "s/^HOOKS=.*/HOOKS=(base udev autodetect modconf block keyboard encrypt lvm2 filesystems fsck)/" > /tmp/buffer
	mv /tmp/buffer /etc/mkinitcpio.conf
	mkinitcpio -p linux &>/dev/null
	echo " done."
	flag 3012
}
