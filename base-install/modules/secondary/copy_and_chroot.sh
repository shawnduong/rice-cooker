# Copy the script to the new install and then chroot. Flags inside chroot start
# at 2002 and may go up to 2049. 2050 is flagged when chroot is done.
copy_and_chroot()
{
	# Copy the script to the new root.
	mkdir -p /mnt/root/setup/
	cp -r ./ /mnt/root/setup/

	# chroot. Flags start at 2002, may go up to 2049. 2050 when done.
	echo " Chrooting to install... new shell will be spawned."
	arch-chroot /mnt bash -c "cd /root/setup && bash panes/secondary_chroot.sh"
	echo -e "\033[0;33m ==[ CHROOT EXITED ]== \033[0;0m"
}
