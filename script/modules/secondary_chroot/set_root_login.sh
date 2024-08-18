source setup.conf
source modules/common/flag.sh

# Set the root password. Flags 2003 to signal ready to receive password, 2004 done.
set_root_login()
{
	# Get the password.
	stty -echo
	flag 2003
	read -r -p " Awaiting root password from controller..." rootPass
	echo " [hidden]"
	stty echo

	# Set the root password.
	echo -n " Setting root password..."
	echo -ne "${rootPass}\n${rootPass}" | passwd &>/dev/null
	echo " done."
	flag 2004
}

