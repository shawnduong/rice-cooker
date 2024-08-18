#!/bin/bash

source setup.conf
source modules/common/checks.sh
source modules/common/flag.sh
source modules/secondary_chroot/make_user_account.sh
source modules/secondary_chroot/set_root_login.sh
source modules/secondary_chroot/set_timezone.sh
source modules/secondary_chroot/sync_hwclock.sh

# Secondary terminal, within the chroot. Flags start at 2002 and may go up to
# 2049. Flags 2050 when done.
secondary_chroot()
{
	# Signal that we're chrooted.
	flag 2002

	echo -e "\033[0;33m ==[ NOW RUNNING CHROOTED ]== \033[0;0m"

	set_root_login     # Flags 2003 to signal ready to receive password, 2004 done.
	make_user_account  # Flags 2005 to signal ready to receive password, 2006 done.
	set_timezone       # Flags 2007.
	sync_hwclock       # Flags 2008.
	set_hostname       # Flags 2009.
	update_hosts       # Flags 2010.

#	# Get the device from the controller.
#	read -r -p " Awaiting device from controller... " device
#	flag 2010
#
#	configure_bootloader "$device"  # Flags 2011
#
#	# Flag controller to pull secondary out of chroot.
#	flag 2050

	sleep 5  # debug
}

secondary_chroot
