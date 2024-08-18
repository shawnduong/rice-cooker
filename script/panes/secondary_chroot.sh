#!/bin/bash

source setup.conf
source modules/common/checks.sh
source modules/common/flag.sh
source modules/secondary_chroot/make_user_account.sh
source modules/secondary_chroot/set_root_login.sh
source modules/secondary_chroot/set_timezone.sh
source modules/secondary_chroot/sync_hwclock.sh

# Secondary terminal, within the chroot. Flags from [2002,2011],2050.
secondary_chroot()
{
	# Signal that we're chrooted.
	flag 2002

	echo -e "\033[0;33m ==[ NOW RUNNING CHROOTED ]== \033[0;0m"

	set_root_login     # Flags 2003 to signal ready to receive password, 2004 done.
	make_user_account  # Flags 2005 to signal ready to receive password, 2006 done.
	set_timezone       # Flags 2007.
	sync_hwclock       # Flags 2008.

#	# Set the hostname.
#	echo -n " Setting hostname..."
#	echo "$HOSTNAME" > /etc/hostname
#	echo " done."
#	flag 2005
#
#	# Add localhost to hosts.
#	echo -n " Adding localhost self to hosts..."
#	echo "" >> /etc/hosts
#	echo "127.0.0.1  $HOSTNAME.net  $HOSTNAME" >> /etc/hosts
#	echo "::1        $HOSTNAME.net  $HOSTNAME" >> /etc/hosts
#	echo " done."
#	flag 2006
#
#	# Generate locale.
#	echo -n " Generating locale..."
#	echo "$LOCALE" >> /etc/locale.gen
#	locale-gen &>/dev/null
#	flag 2007
#	echo " done."
#
#	# Update mkinitcpio hooks.
#	echo -n " Creating initial ramdisk..."
#	cat /etc/mkinitcpio.conf | sed -e "s/^HOOKS=.*/HOOKS=(base udev autodetect modconf block keyboard encrypt lvm2 filesystems fsck)/" > /tmp/buffer
#	mv /tmp/buffer /etc/mkinitcpio.conf
#	mkinitcpio -p linux &>/dev/null
#	echo " done."
#
#	# Get the device from the controller.
#	read -r -p " Awaiting device from controller... " device
#	flag 2010
#
#	configure_bootloader "$device"  # Flags 2011
#
#	# Flag controller to pull secondary out of chroot.
#	flag 2050
}

secondary_chroot
