# Tertiary terminal, within the chroot. Flags [3010,3015],3050.
tertiary_chroot()
{
	flag 3010

	echo -e "\033[0;33m ==[ NOW RUNNING CHROOTED ]== \033[0;0m"

	# Get the password.
	stty -echo
	flag 3011
	read -r -p " Awaiting user password from controller..." password
	echo " [hidden]"
	stty echo
	flag 3012

	# Create sudo user.
	echo -n " Creating sudo user..."
	useradd -m -G wheel "$USERNAME"
	echo -ne "${password}\n${password}" | passwd "$USERNAME" &>/dev/null
	cat /etc/sudoers | sed -e "s/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/" > /tmp/buffer
	mv /tmp/buffer /etc/sudoers
	echo " done."
	flag 3013

	# Install WM/DE, fonts, and X.
	install_user_packages  # Flags 3014
	cat /etc/sudoers | sed -e "s/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/" > /tmp/buffer
	mv /tmp/buffer /etc/sudoers
	cat /etc/sudoers | sed -e "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" > /tmp/buffer
	mv /tmp/buffer /etc/sudoers

	# Configure X to start WM/DE.
	echo -n " Configuring X to automatically start WM/DE..."
	echo "exec i3" > /home/$USERNAME/.xinitrc
	echo " done."

	# Configure Bash profile to automatically start X.
	echo -n " Configuring shell to automatically start X..."
	echo "#"                                         > /home/$USERNAME/.bash_profile
	echo "# ~/.bash_profile"                        >> /home/$USERNAME/.bash_profile
	echo "#"                                        >> /home/$USERNAME/.bash_profile
	echo ""                                         >> /home/$USERNAME/.bash_profile
	echo "[[ -f ~/.bashrc ]] && . ~/.bashrc"        >> /home/$USERNAME/.bash_profile
	echo ""                                         >> /home/$USERNAME/.bash_profile
	echo "if systemctl -q is-active graphical.target && [[ ! \$DISPLAY && \$XDG_VTNR -eq 1 ]]; then" \
	                                                >> /home/$USERNAME/.bash_profile
	echo "	exec startx 1>/dev/null 2>&1"           >> /home/$USERNAME/.bash_profile
	echo "fi"                                       >> /home/$USERNAME/.bash_profile
	echo " done."
	flag 3015

	# Create user home dirs.
	echo -n " Creating user home directories..."
	case $DIRECTORIES in
		"minimal")
			su "$USERNAME" -c "mkdir ~/doc/ ~/dl/ ~/mus/ ~/pic/ ~/doc/public/ ~/doc/templates/ ~/vid/"
			su "$USERNAME" -c "xdg-user-dirs-update --set DESKTOP ~/"
			su "$USERNAME" -c "xdg-user-dirs-update --set DOCUMENTS ~/doc/"
			su "$USERNAME" -c "xdg-user-dirs-update --set DOWNLOAD ~/dl/"
			su "$USERNAME" -c "xdg-user-dirs-update --set MUSIC ~/mus/"
			su "$USERNAME" -c "xdg-user-dirs-update --set PICTURES ~/pic/"
			su "$USERNAME" -c "xdg-user-dirs-update --set PUBLICSHARE ~/doc/public/"
			su "$USERNAME" -c "xdg-user-dirs-update --set TEMPLATES ~/doc/templates/"
			su "$USERNAME" -c "xdg-user-dirs-update --set VIDEOS ~/vid/"
			su "$USERNAME" -c "xdg-user-dirs-update"
			;;
		"full")
			su "$USERNAME" -c "xdg-user-dirs-update"
			;;
		"none")
			;;
	esac
	echo " done."
	flag 3016

	# Flag controller to pull secondary out of chroot.
	flag 3050
}
