# Install essential packages. Flags 3009.
install_essential_packages()
{
	# Enable 5 parallel downloads at a time.
	cat /etc/pacman.conf | sed -e "s/#ParallelDownloads = 5/ParallelDownloads = 5/" > /tmp/buffer
	mv /tmp/buffer /etc/pacman.conf

	# Install essential packages.
	echo -e " Installing essential packages... this may take a while."
	echo -e " \033[0;33m===[ PACKAGE INSTALLATION LOGS ]====\033[0;0m"

	pacstrap /mnt base base-devel linux linux-firmware lvm2 networkmanager vim gnu-netcat
	status="$?"

	echo -e " \033[0;33m====================================\033[0;0m"
	echo -e " Installing essential packages... done."

	if [[ "$status" == 0 ]]; then
		flag 3009
	else
		echo -e "\033[0;31m There was an error during package installation. Please try again. \033[0;0m"
	fi
}
