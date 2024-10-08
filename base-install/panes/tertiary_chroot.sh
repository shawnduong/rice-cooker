#!/bin/bash

source setup.conf
source modules/common/checks.sh
source modules/common/flag.sh
source modules/tertiary_chroot/generate_locale.sh
source modules/tertiary_chroot/generate_ramdisk.sh
source modules/tertiary_chroot/configure_bootloader.sh

# Tertiary terminal, within the chroot. Flags start at 3010 and may go up to
# 3049. Flags 3050 when done.
tertiary_chroot()
{
	# Signal that we're chrooted.
	flag 3010

	echo -e "\033[0;33m ==[ NOW RUNNING CHROOTED ]== \033[0;0m"

	generate_locale       # Flags 3011.
	generate_ramdisk      # Flags 3012.
	configure_bootloader  # Flags 3013 to signal ready to receive device, 3014 done.

	# Wait for the signal to exit chroot.
	check 1002
}

tertiary_chroot
