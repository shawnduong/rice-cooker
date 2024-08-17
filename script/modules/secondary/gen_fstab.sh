# Generate the fstab. Flags 2001.
gen_fstab()
{
	echo -n " Generating fstab..."
	genfstab -U /mnt >> /mnt/etc/fstab
	echo " done."
	flag 2001
}
