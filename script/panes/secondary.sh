#!/bin/bash

source modules/common/checks.sh
source modules/common/flag.sh
source modules/common/suppress_systemd.sh
source modules/secondary/enable_ntp.sh
source modules/secondary/gen_fstab.sh
source modules/secondary/copy_and_chroot.sh

# Secondary quick-task terminal.
secondary()
{
	clear
	suppress_systemd

	enable_ntp        # Flags 2000

	# Wait for the signal from the controller to continue.
	check_silent 1000

	gen_fstab         # Flags 2001
	copy_and_chroot   # Flags start at 2002 and may go up to 2049. 2050 when done.

	# We're all done.
	flag 2100
}

secondary
