#!/bin/bash

source modules/common/checks.sh
source modules/common/flag.sh
source modules/common/get_password.sh
source modules/primary/get_format_device.sh

# Primary controller terminal. This is the left terminal. All flags originating
# from this terminal are 1xxx.
primary()
{
	clear

	# Start the scripts on the secondary and tertiary terminals.
	tmux send-keys -t 1 "bash panes/secondary.sh" Enter
	tmux send-keys -t 2 "bash panes/tertiary.sh" Enter

	# Get the device to format.
	get_format_device
	device="$ret"

	# Send the device to format to the tertiary.
	tmux send-keys -t 2 "$device" Enter

	# Make the encryption key.
	get_password "\n\n Please create an encryption key."
	encKey="$ret"
	# Send the encryption key to the tertiary.
	check_silent 3001
	tmux send-keys -t 2 "$encKey" Enter

	# Make the passwords.
	get_password "\n\n Please create a root account password."
	rootPass="$ret"
	get_password "\n\n Please create a user account password."
	userPass="$ret"

	clear

	echo -e "\n Status"
	check 2000 "   Enabling NTP             "
	check 3000 "   Partitioning disk        "
	check 3001 "   Formatting boot          "
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

	check_chroot_silent 2002  # Wait for the secondary to chroot,
	flag 1001                 # then tell the tertiary to chroot.

	check_chroot 3010 "   chrooting into install   "
}

primary