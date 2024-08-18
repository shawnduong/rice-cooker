source modules/common/checks.sh

# Check for flag 1001 from the controller, then chroot into the new install.
# Flags inside the chroot start at 3010 and may go up to 3049. 3050 is flagged
# when chroot is done.
check_and_chroot()
{
	# Make sure that we're clear to chroot. 1001 should only be flagged by the
	# primary after the secondary has copied the script into the new install.
	check_silent 1001

	# chroot. Flags start at 3010, may go up to 3049. 3050 when done.
	echo " Chrooting to install... new shell will be spawned."
	chroot /mnt bash -c "cd /root/setup && bash panes/tertiary_chroot.sh"
	echo -e "\033[0;33m ==[ CHROOT EXITED ]== \033[0;0m"
}
