#!/bin/bash

source setup.conf
source modules/common/checks.sh
source modules/common/flag.sh
source modules/tertiary/prepare_device.sh
source modules/tertiary/install_essential_packages.sh

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
	# At this point, the primary terminal will send keys over to the chrooted
	# pane to start tertiary_chroot.sh. The secondary already copied
	# tertiary_chroot.sh to /root/setup/ since it was idling. When it exits,
	# it'll return here.

	# Signal that secondary has successfully exited chroot.
	echo -e "\033[0;33m ==[ EXITING CHROOT ]== \033[0;0m"
	flag 3100
}

tertiary
