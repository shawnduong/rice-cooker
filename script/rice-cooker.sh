#!/bin/sh

# CLI arguments.
arg0="$1"

# Rice cooker configuration:
# Locale
TIMEZONE="US/Pacific"
LOCALE="en_US.UTF-8 UTF-8"
# Disk
ENCRYPT="Yes"
# Partitions
SIZE_BOOT="512M"
SIZE_SWAP="1G"
SIZE_ROOT="8G"
SIZE_HOME="remainder"
# System
USERNAME="spicy"
HOSTNAME="rice"
DIRECTORIES="minimal"
# Defaults
WMDE="i3-gaps"
COMPOSITOR="picom"
LAUNCHER="rofi"
BAR="polybar"
TERMINAL="st"
EDITOR="vim"
LOCKSCREEN="i3lock"
WALLPAPER="feh"
BROWSER="firefox"
# Drivers
DISPLAY="intel"
WIFI="rtl88xxau-aircrack-dkms-git"
# Dev Packs
DEV_PACKS=("netsec" "forensics" "jekyll")

# Print the banner.
print_banner()
{
	echo "┌───────────────────────────┐"
	echo "│        RICE COOKER        │"
	echo "│       by shawnd.xyz       │"
	echo "└───────────────────────────┘"
}

# Print an exit message and then quit.
# $1 = exit message
end()
{
	echo -e "\n$1"
	exit -1
}

# Ask the user to confirm Y/N.
# $1 = prompt
# => 0 if Y, 1 if N.
confirm()
{
	while true; do

		read -r -p " $1 [y/n] " input

		case $input in
			[yY][eE][sS]|[yY])
				return 0
				;;
			[nN][oO]|[nN])
				return 1
				;;
			*)
				echo -e " Sorry, I didn't understand that.\n"
				;;
		esac

	done
}

# Get a password from the user. Do not echo the password.
# $1 = prompt
# => password
get_password()
{
	echo -e "$1\n"

	while true; do

		stty -echo
		read -r -p " Password: " password
		echo ""
		read -r -p " Confirm: " confirm
		stty echo

		if [[ "$password" == "$confirm" ]]; then
			break;
		else
			echo -e "\n\n Passwords did not match.\n"
		fi

	done

	ret="$password"
}

# Wait until a flag is detected.
# $1 = flag number
# $2 = message to write to the screen
check()
{
	echo -n "$2"

	while true; do
		sleep 0.1
		ls "/tmp/$1" &>/dev/null && echo -e "\033[0;32m Done \033[0;0m" && return
	done
}

# Silent check.
# $1 = flag number
check_silent()
{
	while true; do
		sleep 0.1
		ls "/tmp/$1" &>/dev/null && return
	done
}

# Wait until a flag is detected in a system chrooted at /mnt. The controller
# should not be chrooted, but will detect a flag from a chrooted terminal.
# $1 = flag number
# $2 = message to write to the screen
check_chroot()
{
	echo -n "$2"

	while true; do
		sleep 0.1
		ls "/mnt/tmp/$1" &>/dev/null && echo -e "\033[0;32m Done \033[0;0m" && return
	done
}

# Silent check.
# $1 = flag number
check_chroot_silent()
{
	while true; do
		sleep 0.1
		ls "/mnt/tmp/$1" &>/dev/null && return
	done
}

# Mark a flag. If the terminal is chrooted, the controller should use
# check_chroot to find the flag.
# $1 = flag number
flag()
{
	touch "/tmp/$1"
}

# Tries to ping archlinux.org with 4 attempts.
# => 0 if able to, 1 if not.
check_connectivity()
{
	for i in {0..4}; do
		if ping -c 1 archlinux.org &>/dev/null; then
			return 0
		fi
	done

	return 1
}

# Checks if the system is EFI.
# => 0 if so, 1 if not.
check_efi()
{
	if ls /sys/firmware/efi/efivars &>/dev/null; then
		return 0
	fi

	return 1
}

# Get the device to format from the user.
# => device name
get_format_device()
{
	while true; do

		echo ""
		echo " Which device would you like to format?"
		echo ""
		echo " Device  Size    Type"
		echo " --------------------------"
		lsblk | tail +2 | grep -v "rom\|loop" |
			awk -F ' ' '{printf " \033[0;32m%-7s\033[0;0m %-7s %-7s\n", $1, $4, $6}'
		echo ""
		echo -n " Hint: it's likely the largest device. It'll probably start with"
		echo -e " \033[0;36msd\033[0;0m or \033[0;36mnvme\033[0;0m."
		echo ""
		read -r -p " Device: " device
		echo ""
		echo " Are you absolutely positively most-definitely sure?"
		echo " Warning: this will erase all data currently on that device."
		echo ""

		if confirm "I am sure."; then
			echo -e "\n Proceeding with disk formatting."
			break
		fi

	done

	ret="$device"
}

# Partition, format, mount, etc. the device. Flags from [3000,3008]. Should be
# run by the tertiary.
prepare_device()
{
	# Partition the disk.

	read -r -p " Awaiting device from controller... " device
	sgdisk -o "/dev/$device" >/dev/null

	echo -n " Creating boot partition..."
	sgdisk --new "0:0:+$SIZE_BOOT" -t 0:ef00 "/dev/$device" >/dev/null
	echo " done."

	echo -n " Creating lvm partition..."
	sgdisk --new "0:0:0" -t 0:8e00 "/dev/$device" >/dev/null
	echo " done."

	flag 3000

	if [[ "$device" == "nvme*" ]]; then
		devBoot="/dev/${device}p1"
		devLvm="/dev/${device}p2"
	else
		devBoot="/dev/${device}1"
		devLvm="/dev/${device}2"
	fi

	# Format the boot partition.

	echo -n " Formatting the boot partition..."
	mkfs.fat -F32 "$devBoot" >/dev/null
	echo " done."
	stty -echo
	flag 3001

	# Format the LVM partition.

	read -r -p " Awaiting encryption key from controller..." encKey
	echo " [hidden]"
	stty echo

	modprobe dm-crypt

	echo -n " Formatting the LVM partition..."
	echo -n "$encKey" | cryptsetup -q luksFormat "$devLvm"
	echo " done."
	flag 3002

	# Partition the LVM partition.

	echo -n " Opening the LVM partition..."
	echo -n "$encKey" | cryptsetup open --type luks "$devLvm" lvm >/dev/null
	echo " done."

	pvcreate /dev/mapper/lvm >/dev/null
	vgcreate vg0 /dev/mapper/lvm >/dev/null
	echo -n " Creating swap..."
	lvcreate -L "$SIZE_SWAP" vg0 -n swap >/dev/null
	echo " done."

	echo -n " Creating root..."
	lvcreate -L "$SIZE_ROOT" vg0 -n root >/dev/null
	echo " done."

	echo -n " Creating home..."
	if [[ "$SIZE_HOME" == "remainder" ]]; then
		lvcreate -l 100%FREE vg0 -n home >/dev/null
	else
		lvcreate -L "$SIZE_HOME" vg0 -n home >/dev/null
	fi
	echo " done."

	flag 3003

	# Make the swap.

	echo -n " Making swap..."
	mkswap /dev/vg0/swap >/dev/null
	echo " done."
	flag 3004

	# Format root.

	echo -n " Formatting root..."
	mkfs.ext4 -q /dev/vg0/root
	echo " done."
	flag 3005

	# Format home.

	echo -n " Formatting home..."
	mkfs.ext4 -q /dev/vg0/home
	echo " done."
	flag 3006

	# Mount everything.

	echo -n " Mounting root..."
	mount /dev/vg0/root /mnt
	echo " done."

	echo -n " Mounting boot..."
	mkdir /mnt/boot /mnt/home
	mount "$devBoot" /mnt/boot
	echo " done."

	echo -n " Mounting home..."
	mount /dev/vg0/home /mnt/home
	echo " done."

	flag 3007

	# Enable swap.

	echo -n " Enabling swap..."
	swapon /dev/vg0/swap
	echo " done."
	flag 3008
}

# Install essential packages. Flags 3009.
install_essential_packages()
{
	# Enable 5 parallel downloads at a time.
	cat /etc/pacman.conf | sed -e "s/#ParallelDownloads = 5/ParallelDownloads = 5/" > /tmp/buffer
	mv /tmp/buffer /etc/pacman.conf

	# Install essential packages.
	echo -e " Installing essential packages... this may take a while."
	echo -e " \033[0;33m===[ PACKAGE INSTALLATION LOGS ]====\033[0;0m"

	pacstrap /mnt base base-devel linux linux-firmware lvm2 networkmanager vim
	status="$?"

	echo -e " \033[0;33m====================================\033[0;0m"
	echo -e " Installing essential packages... done."

	if [[ "$status" == 0 ]]; then
		flag 3009
	else
		echo -e "\033[0;31m There was an error during package installation. Please try again. \033[0;0m"
	fi
}

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

# Configure the bootloader. Flags 2011.
# $1 = device
configure_bootloader()
{
	echo -n " Configuring bootloader..."

	if [[ "$1" == "nvme*" ]]; then
		devLvm="/dev/${1}p2"
	else
		devLvm="/dev/${1}2"
	fi

	uuid=$(blkid "$devLvm" | cut -d '"' -f 2)
	bootctl --path=/boot install &>/dev/null

	# Write to /boot/loader/loader.conf.
	echo "default arch" > /boot/loader/loader.conf
	echo "timeout 3"   >> /boot/loader/loader.conf
	echo "editor 0"    >> /boot/loader/loader.conf

	# Write to /boot/loader/entries/arch.conf
	echo "title Arch Linux"             > /boot/loader/entries/arch.conf
	echo "linux /vmlinuz-linux"        >> /boot/loader/entries/arch.conf
	echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
	echo "options cryptdevice=UUID=\"${uuid}\":lvm root=/dev/mapper/vg0-root quiet rw" >> /boot/loader/entries/arch.conf
	echo " done."

	flag 2011
}

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

# Secondary quick-task terminal.
secondary()
{
	clear

	# Suppress systemd messages to console.
	/usr/bin/kill -SIGRTMIN+21 1

	# Enable NTP.
	echo -n " Enabling NTP..."
	timedatectl set-ntp true
	echo " done."
	flag 2000

	# Wait for the signal from the controller to continue.
	check_silent 1000

	# Generate the fstab.
	echo -n " Generating fstab..."
	genfstab -U /mnt >> /mnt/etc/fstab
	echo " done."
	flag 2001

	# chroot.
	echo " Chrooting to install... new shell will be spawned."
	cp /root/rice-cooker.sh /mnt/root/rice-cooker.sh
	arch-chroot /mnt  # Flags [2002,2011],2050

	# Signal that secondary has successfully exited chroot.
	echo -e "\033[0;33m ==[ EXITING CHROOT ]== \033[0;0m"
	flag 2100
}

# Secondary terminal, within the chroot. Flags from [2002,2011],2050.
secondary_chroot()
{
	flag 2002

	echo -e "\033[0;33m ==[ NOW RUNNING CHROOTED ]== \033[0;0m"

	# Set the timezone.
	echo -n " Setting timezone..."
	ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
	echo " done."
	flag 2003

	# Synchronize the hardware clock.
	echo -n " Synchronizing hardware clock..."
	hwclock --systohc
	echo " done."
	flag 2004

	# Set the hostname.
	echo -n " Setting hostname..."
	echo "$HOSTNAME" > /etc/hostname
	echo " done."
	flag 2005

	# Add localhost to hosts.
	echo -n " Adding localhost self to hosts..."
	echo "" >> /etc/hosts
	echo "127.0.0.1  $HOSTNAME.net  $HOSTNAME" >> /etc/hosts
	echo "::1        $HOSTNAME.net  $HOSTNAME" >> /etc/hosts
	echo " done."
	flag 2006

	# Generate locale.
	echo -n " Generating locale..."
	echo "$LOCALE" >> /etc/locale.gen
	locale-gen &>/dev/null
	flag 2007
	echo " done."

	# Update mkinitcpio hooks.
	echo -n " Creating initial ramdisk..."
	cat /etc/mkinitcpio.conf | sed -e "s/^HOOKS=.*/HOOKS=(base udev autodetect modconf block keyboard encrypt lvm2 filesystems fsck)/" > /tmp/buffer
	mv /tmp/buffer /etc/mkinitcpio.conf
	mkinitcpio -p linux &>/dev/null
	echo " done."
	stty -echo
	flag 2008

	# Set the root password.
	read -r -p " Awaiting root password from controller..." rootPass
	echo " [hidden]"
	stty echo
	echo -n " Setting root password..."
	echo -ne "${rootPass}\n${rootPass}" | passwd &>/dev/null
	echo " done."
	flag 2009

	# Get the device from the controller.
	read -r -p " Awaiting device from controller... " device
	flag 2010

	configure_bootloader "$device"  # Flags 2011

	# Flag controller to pull secondary out of chroot.
	flag 2050
}

# Tertiary long-task terminal.
tertiary()
{
	clear

	prepare_device              # Flags [3000,3008]
	install_essential_packages  # Flags 3009

	# chroot.
	check_silent 1001
	echo " Chrooting to install... new shell will be spawned."
	chroot /mnt "/bin/bash"  # Flags [3010,3015],3050

	# Signal that secondary has successfully exited chroot.
	echo -e "\033[0;33m ==[ EXITING CHROOT ]== \033[0;0m"
	flag 3100
}

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

	# Enable NetworkManager.
	echo -n " Enabling NetworkManager..."
	systemctl enable NetworkManager &>/dev/null
	echo " done."
	flag 3017

	# Flag controller to pull secondary out of chroot.
	flag 3050
}

main()
{
	print_banner
	echo " This project is in early development. Many features have not been implemented"
	echo " yet. Please report all bugs: https://github.com/shawnduong/rice-cooker/issues"

	echo -e "\n Performing checks:"

	# Check that archlinux.org is reachable.
	echo -n "   Network "
	if check_connectivity; then
		echo -e "\033[0;32m Good \033[0;0m"
	else
		echo -e "\033[0;31m Error \033[0;0m"
		end " Please check your network connection and try again."
	fi

	# Check that EFI is enabled.
	echo -n "   EFI     "
	if check_efi; then
		echo -e "\033[0;32m Good \033[0;0m"
	else
		echo -e "\033[0;31m Error \033[0;0m"
		end " You're not in EFI mode. Check your BIOS and try again."
	fi

	echo -e ""
	echo -e " Rice cooker configuration:"
	echo -e "   Locale"
	echo -e "     Timezone \033[0;36m $TIMEZONE \033[0;0m"
	echo -e "     Locale   \033[0;36m $LOCALE   \033[0;0m"
	echo -e "   Disk"
	echo -e "     Encrypt \033[0;36m $ENCRYPT \033[0;0m"
	echo -e "     Partitions"
	echo -e "     ├─boot \033[0;36m $SIZE_BOOT \033[0;0m"
	echo -e "     ├─swap \033[0;36m $SIZE_SWAP \033[0;0m"
	echo -e "     ├─root \033[0;36m $SIZE_ROOT \033[0;0m"
	echo -e "     └─home \033[0;36m $SIZE_HOME \033[0;0m"
	echo -e "   System"
	echo -e "     Username    \033[0;36m $USERNAME    \033[0;0m"
	echo -e "     Hostname    \033[0;36m $HOSTNAME    \033[0;0m"
	echo -e "     Directories \033[0;36m $DIRECTORIES \033[0;0m"
	echo -e "   Defaults"
	echo -e "     WM/DE      \033[0;36m $WMDE       \033[0;0m"
	echo -e "     Compositor \033[0;36m $COMPOSITOR \033[0;0m"
	echo -e "     Launcher   \033[0;36m $LAUNCHER   \033[0;0m"
	echo -e "     Bar        \033[0;36m $BAR        \033[0;0m"
	echo -e "     Terminal   \033[0;36m $TERMINAL   \033[0;0m"
	echo -e "     Editor     \033[0;36m $EDITOR     \033[0;0m"
	echo -e "     Lockscreen \033[0;36m $LOCKSCREEN \033[0;0m"
	echo -e "     Wallpaper  \033[0;36m $WALLPAPER  \033[0;0m"
	echo -e "     Browser    \033[0;36m $BROWSER    \033[0;0m"
	echo -e "   Drivers"
	echo -e "     Display \033[0;36m $DISPLAY \033[0;0m"
	echo -e "     Wi-Fi   \033[0;36m $WIFI    \033[0;0m"
	echo -e "   Dev Packs"
	echo -n "     "
	for (( i=0; i < ${#DEV_PACKS[@]}-1; i++ )); do
		echo -en "\033[0;36m${DEV_PACKS[i]}\033[0;0m, "
	done
	echo -e "\033[0;36m${DEV_PACKS[i]}\033[0;0m"

	echo ""
	if confirm "Ready to install?"; then
		echo -e "\n Starting installation."
	else
		end " Aborting installation."
	fi

	# Start termux with 3 panes, and start the primary.
	tmux new-session \; split-window -h \; split-window -v \; attach \; \
		select-pane -t 0 \; send-keys -t 0 "sleep 0.1; sh rice-cooker.sh primary" Enter
}

if [[ "$arg0" == "" ]]; then
	main
elif [[ "$arg0" == "primary" ]]; then
	primary
elif [[ "$arg0" == "secondary" ]]; then
	secondary
elif [[ "$arg0" == "secondary_chroot" ]]; then
	secondary_chroot
elif [[ "$arg0" == "tertiary" ]]; then
	tertiary
elif [[ "$arg0" == "tertiary_chroot" ]]; then
	tertiary_chroot
else
	echo "Unknown input."
fi
