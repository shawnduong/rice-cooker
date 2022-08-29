# Install user packages. Flags 3014.
# TODO: replace this with user options.
install_user_packages()
{
	# Enable 5 parallel downloads at a time.
	cat /etc/pacman.conf | sed -e "s/#ParallelDownloads = 5/ParallelDownloads = 5/" > /tmp/buffer
	mv /tmp/buffer /etc/pacman.conf

	echo -e " Installing user packages... this may take a while."
	echo -e " \033[0;33m===[ PACKAGE INSTALLATION LOGS ]====\033[0;0m"

	# WM/DE and display packages.
	packages="i3-gaps ttf-dejavu xorg xorg-xinit xterm picom"

	# Rice options.
	packages="$packages rofi polybar vim i3lock feh firefox"

	# Display drivers.
	packages="$packages xf86-video-intel mesa"

	# Terminal.
	# TODO

	# Other.
	packages="$packages git"

	# Install packages.
	pacman -Sy --noconfirm $packages

	# Install yay.
	su "$USERNAME" -c "cd /tmp && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin/ && makepkg -si --noconfirm"
	su "$USERNAME" -c "yay -Syu --devel && yay -Y --devel --save"

	# Wi-Fi drivers.
	aurPackages="rtl88xxau-aircrack-dkms-git"

	su "$USERNAME" -c "yay -Sy --noconfirm $aurPackages"

	echo -e " \033[0;33m====================================\033[0;0m"
	echo -e " Installing user packages... done."

	flag 3014
}
