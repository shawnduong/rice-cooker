# Tertiary long-task terminal.
tertiary()
{
	clear

	prepare_device              # Flags [3000,3008]
	install_essential_packages  # Flags 3009

	# chroot.
	check_silent 1001
	echo " Chrooting to install... new shell will be spawned."
	chroot /mnt "/bin/bash"  # Flags [3010,3015],3050

	# Signal that secondary has successfully exited chroot.
	echo -e "\033[0;33m ==[ EXITING CHROOT ]== \033[0;0m"
	flag 3100
}
