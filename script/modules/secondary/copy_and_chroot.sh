# Copy the script to the new install and then chroot. Flags inside chroot start
# at 2002 and may go up to 2049. 2050 is flagged when chroot is done.
copy_and_chroot()
{
	# chroot.
	echo " Chrooting to install... new shell will be spawned."
	mkdir -p /mnt/root/setup/
	cp -r ./ /mnt/root/setup/
	arch-chroot /mnt  # Flags start at 2002, may go up to 2049. 2050 when done.
	# At this point, the primary terminal will send keys over to the chrooted
	# pane to start secondary_chroot.sh. When it exits, it'll return here.

	# Signal that secondary has successfully exited chroot.
	echo -e "\033[0;33m ==[ EXITING CHROOT ]== \033[0;0m"
}
