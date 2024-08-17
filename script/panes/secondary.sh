#!/bin/bash

source modules/common/checks.sh
source modules/common/flag.sh

# Secondary quick-task terminal.
secondary()
{
	clear

	# Suppress systemd messages to console.
	/usr/bin/kill -SIGRTMIN+21 1

	# Enable NTP.
	echo -n " Enabling NTP..."
	timedatectl set-ntp true
	echo " done."
	flag 2000

	# Wait for the signal from the controller to continue.
	check_silent 1000

	# Generate the fstab.
	echo -n " Generating fstab..."
	genfstab -U /mnt >> /mnt/etc/fstab
	echo " done."
	flag 2001

	# chroot.
	echo " Chrooting to install... new shell will be spawned."
	mkdir -p /mnt/root/setup/
	cp -r ./ /mnt/root/setup/
	arch-chroot /mnt  # Flags [2002,2011],2050
	# At this point, the primary terminal will send keys over to the chrooted
	# pane to start secondary_chroot.sh. When it exits, it'll return here.

	# Signal that secondary has successfully exited chroot.
	echo -e "\033[0;33m ==[ EXITING CHROOT ]== \033[0;0m"
	flag 2100
}

secondary
