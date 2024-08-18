#!/bin/bash

source modules/common/flag.sh
source modules/tertiary/prepare_device.sh
source modules/tertiary/install_essential_packages.sh
source modules/tertiary/check_and_chroot.sh

# Tertiary long-task terminal.
tertiary()
{
	clear

	prepare_device              # Flags [3000,3008]
	install_essential_packages  # Flags 3009
	check_and_chroot            # Checks 1001. Flags start at 3010 and may go
	                            # up to 3049. 3050 is flagged when done.
	# We're all done.
	flag 3100
}

tertiary
