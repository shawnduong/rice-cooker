# Primary controller terminal. This is the left terminal. All flags originating
# from this terminal are 1xxx.
primary()
{
	clear

	print_banner

	# Start the scripts on the secondary and tertiary terminals.
	tmux send-keys -t 1 "sh rice-cooker.sh secondary" Enter
	tmux send-keys -t 2 "sh rice-cooker.sh tertiary" Enter

	# Get the device to format.
	get_format_device
	device="$ret"

	# Make the passwords.
	get_password "\n\n Please create an encryption key."
	encKey="$ret"
	get_password "\n\n Please create a root account password."
	rootPass="$ret"
	get_password "\n\n Please create a user account password."
	userPass="$ret"

	# Send the device to format to the tertiary.
	tmux send-keys -t 2 "$device" Enter

	echo -e "\n\n Status"
	check 2000 "   Enabling NTP             "
	check 3000 "   Partitioning disk        "
	check 3001 "   Formatting boot          "

	# Send the encryption key to the tertiary.
	sleep 1
	tmux send-keys -t 2 "$encKey" Enter

	check 3002 "   Formatting lvm           "
	check 3003 "   Partitioning lvm         "
	check 3004 "   Making swap              "
	check 3005 "   Formatting root          "
	check 3006 "   Formatting home          "
	check 3007 "   Mounting partitions      "
	check 3008 "   Enabling swap            "
	check 3009 "   Installing packages      "

	# Signal to the secondary to continue.
	flag 1000

	check 2001 "   Generating fstab         "

	sleep 1
	tmux send-keys -t 1 "sh /root/rice-cooker.sh secondary_chroot" Enter
	flag 1001
	sleep 1
	tmux send-keys -t 2 "sh /root/rice-cooker.sh tertiary_chroot" Enter

	check_chroot_silent 3010
	check_chroot 2002 "   Chrooting to /mnt        "

	check_chroot_silent 3011
	sleep 1
	tmux send-keys -t 2 "$userPass" Enter
	check_chroot_silent 3012

	check_chroot 3013 "   Creating user account    "
	check_chroot 2003 "   Setting timezone         "
	check_chroot 2004 "   Syncing hw clock         "
	check_chroot 2005 "   Setting hostname         "
	check_chroot 2006 "   Updating hosts           "
	check_chroot 2007 "   Generating locale        "
	check_chroot 2008 "   Making initial ramdisk   "

	sleep 1
	tmux send-keys -t 1 "$rootPass" Enter

	check_chroot 2009 "   Setting root password    "

	# Send the device to the chrooted secondary.
	sleep 1
	tmux send-keys -t 1 "$device" Enter

	# Wait for the signal from the chrooted secondary to continue.
	check_chroot_silent 2010

	check_chroot 2011 "   Configuring bootloader   "
	check_chroot 3014 "   Installing user packages "
	check_chroot 3015 "   Configuring X init WM/DE "
	check_chroot 3016 "   Creating user home dirs  "
	check_chroot 3017 "   Enabling NetworkManager  "

	# Pull the tertiary out of chroot.
	check_chroot_silent 3050
	sleep 1
	tmux send-keys -t 2 "exit" Enter

	# Pull the secondary out of chroot.
	check_chroot_silent 2050
	sleep 1
	tmux send-keys -t 1 "exit" Enter

	check_silent 3100
	check 2100 "   Exiting chroot           "

	echo ""
	echo " Installation complete. Rebooting now."

	check 9999

	sleep 3
	reboot
}
