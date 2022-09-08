# Install user packages. Flags 3014.
# TODO: replace this with user options.
install_user_packages()
{
	# Enable 5 parallel downloads at a time.
	cat /etc/pacman.conf | sed -e "s/#ParallelDownloads = 5/ParallelDownloads = 5/" > /tmp/buffer
	mv /tmp/buffer /etc/pacman.conf

	echo -e " Installing user packages... this may take a while."
	echo -e " \033[0;33m===[ PACKAGE INSTALLATION LOGS ]====\033[0;0m"

	# Fallback terminal.
	packages="xterm"

	# xdg-user-dirs creates and handles user home directories.
	packages+=" xdg-user-dirs"

	# WM/DE
	case $WMDE in
		"i3-gaps")
			packages+=" i3-gaps"
			;;
		"i3")
			packages+=" i3"
			;;
	esac

	# Compositor.
	packages+=" $COMPOSITOR"

	# Default fonts.
	packages+=" ttf-dejavu"

	# Display packages.
	packages+=" xorg xorg-xinit"

	# Rice options.
	packages+=" $LAUNCHER $BAR $EDITOR $LOCKSCREEN $WALLPAPER $BROWSER"

	# Display drivers.
	case $DISPLAY in
		"intel")
			packages+=" xf86-video-intel mesa"
			;;
	esac

	# Terminal.
	case $TERMINAL in
		"st")
#			install_st  # TODO
			;;
		*)
			packages+=" $TERMINAL"
			;;
	esac

	# Other.
	packages+=" git"

	# Install packages.
	pacman -Sy --noconfirm $packages

	# Install yay.
	su "$USERNAME" -c "cd /tmp && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin/ && makepkg -si --noconfirm"
	su "$USERNAME" -c "yay -Syu --devel && yay -Y --devel --save"

	aurPackages=""

	# Wi-Fi drivers.
	case $WIFI in
		"rtl88xxau-aircrack-dkms-git")
			aurPackages+=" rtl88xxau-aircrack-dkms-git"
			;;
	esac

	su "$USERNAME" -c "yay -Sy --noconfirm $aurPackages"

	echo -e " \033[0;33m====================================\033[0;0m"
	echo -e " Installing user packages... done."

	flag 3014
}
