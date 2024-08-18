source setup.conf
source modules/common/flag.sh

# Make a sudo user. Flags 2005 to signal ready to receive password, 2006 done.
make_user_account()
{
	# Get the password.
	stty -echo
	flag 2005
	read -r -p " Awaiting user password from controller..." password
	echo " [hidden]"
	stty echo

	# Create sudo user.
	echo -n " Creating sudo user..."
	useradd -m -G wheel "$USERNAME"
	echo -ne "${password}\n${password}" | passwd "$USERNAME" &>/dev/null
	cat /etc/sudoers | sed -e "s/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/" > /tmp/buffer
	mv /tmp/buffer /etc/sudoers
	echo " done."
	flag 2006
}
