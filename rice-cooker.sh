#!/bin/sh

# Rice cooker settings.

TIMEZONE="US/Pacific"

ENCRYPT="Yes"
SIZE_BOOT="512M"
SIZE_SWAP="1G"
SIZE_ROOT="8G"
SIZE_HOME="remainder"

USERNAME="spicy"
HOSTNAME="rice"

WMDE="i3-gaps"
LAUNCHER="rofi"
BAR="polybar"
TERMINAL="st"
EDITOR="vim"
BROWSER="firefox"

DRIVERS="intel"

DEV_PACKS=("netsec" "forensics" "jekyll")

# Arguments.
func="$1"

# $1 = exit message
end()
{
	echo ""
	echo "$1"
	exit
}

# $1 = prompt
# Returns 0 if Y, 1 if N.
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
				echo " Sorry, I didn't understand that."
				echo ""
				;;
		esac

	done
}

# Returns 0 if able to ping archlinux.org, 1 if not.
check_connectivity()
{
	if ping -c 1 archlinux.org 2>/dev/null 1>/dev/null; then
		return 0
	fi

	return 1
}

# Returns 0 if efi, 1 if not.
check_efi()
{
	if ls /sys/firmware/efi/efivars 2>/dev/null 1>/dev/null; then
		return 0
	fi

	return 1
}

# $1 = port
# Keep trying to connect to a port to see if it's open.
chck()
{
	while true; do
		sleep 0.1
		nc -z localhost "$1" && return
	done
}

# Primary controller terminal.
primary()
{
	clear

	echo "┌───────────────────────────┐"
	echo "│        RICE COOKER        │"
	echo "│       by shawnd.xyz       │"
	echo "└───────────────────────────┘"

	tmux send-keys -t 1 "sh rice-cooker.sh secondary" Enter
	tmux send-keys -t 2 "sh rice-cooker.sh tertiary" Enter

	while true; do

		echo ""
		echo " Which device would you like to format?"
		echo ""
		echo " Device  Size    Type"
		echo " --------------------------"
		lsblk | tail +2 | grep -v "rom\|loop" |
			awk -F ' ' '{printf " \033[0;32m%-7s\033[0;0m %-7s %-7s\n", $1, $4, $6}'
		echo ""
		echo " Hint: it's likely the largest device."
		echo -e " It'll probably start with \033[0;36msd\033[0;0m or \033[0;36mnvme\033[0;0m."
		echo ""
		read -r -p " Device: " device

		echo ""
		echo " Are you absolutely positively most-definitely sure?"
		echo " Warning: this will erase all data currently on that device."
		echo ""
		if confirm "I am sure."; then
			echo ""
			echo " Proceeding with disk formatting."
			break
		fi

	done

	echo ""
	echo " Please create an encryption volume password."
	echo ""

	while true; do

		stty -echo
		read -r -p " Password: " encKey
		echo ""
		read -r -p " Confirm: " confirm
		stty echo

		if [[ "$encKey" == "$confirm" ]]; then
			break;
		else
			echo ""
			echo ""
			echo " Passwords did not match."
			echo ""
		fi

	done

	tmux send-keys -t 2 "$device" Enter

	echo ""
	echo ""
	echo " Status"

	echo -n "   Enabling NTP        "
	chck 8000
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Partitioning disk   "
	chck 9000
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Formatting boot     "
	chck 9001
	echo -e "\033[0;32m Done \033[0;0m"

	sleep 1
	tmux send-keys -t 2 "$encKey" Enter

	echo -n "   Formatting lvm      "
	chck 9002
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Partitioning lvm    "
	chck 9003
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Making swap         "
	chck 9004
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Formatting root     "
	chck 9005
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Formatting home     "
	chck 9006
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Mounting partitions "
	chck 9007
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Enabling swap       "
	chck 9008
	echo -e "\033[0;32m Done \033[0;0m"

	echo -n "   Installing packages "
	chck 9009
	echo -e "\033[0;32m Done \033[0;0m"
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
	nc -l localhost -p 8000
}

# Tertiary long-task terminal.
tertiary()
{
	clear

	# Partition the disk.

	read -r -p " Awaiting device from controller... " device
	sgdisk -o "/dev/$device" >/dev/null

	echo -n " Creating boot partition..."
	sgdisk --new "0:0:+$SIZE_BOOT" -t 0:ef00 "/dev/$device" >/dev/null
	echo " done."

	echo -n " Creating lvm partition..."
	sgdisk --new "0:0:0" -t 0:8e00 "/dev/$device" >/dev/null
	echo " done."

	nc -l localhost -p 9000

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
	nc -l localhost -p 9001

	# Format the LVM partition.

	read -r -p " Awaiting encryption key from controller..." encKey
	echo " [hidden]"
	stty echo

	modprobe dm-crypt

	echo -n " Formatting the LVM partition..."
	echo -n "$encKey" | cryptsetup -q luksFormat "$devLvm"
	echo " done."
	nc -l localhost -p 9002

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

	nc -l localhost -p 9003

	# Make the swap.
	echo -n " Making swap..."
	mkswap /dev/vg0/swap >/dev/null
	echo " done."
	nc -l localhost -p 9004

	# Format root.
	echo -n " Formatting root..."
	mkfs.ext4 -q /dev/vg0/root
	echo " done."
	nc -l localhost -p 9005

	# Format home.
	echo -n " Formatting home..."
	mkfs.ext4 -q /dev/vg0/home
	echo " done."
	nc -l localhost -p 9006

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

	nc -l localhost -p 9007

	# Enable swap.
	echo -n " Enabling swap..."
	swapon /dev/vg0/swap
	echo " done."
	nc -l localhost -p 9008

#	# Install essential packages.
#	echo " Installing essential packages... this may take a while."
#	pacstrap /mnt base base-devel linux linux-firmware lvm2
#	echo " Installing essential packages... done."
#	nc -l localhost -p 9009
}

main()
{
	echo "┌───────────────────────────┐"
	echo "│        RICE COOKER        │"
	echo "│       by shawnd.xyz       │"
	echo "└───────────────────────────┘"
	echo " This project is in early development. Many features have not been implemented"
	echo " yet. Please report all bugs: https://github.com/shawnduong/rice-cooker/issues"

	echo ""
	echo " Performing checks:"

	if check_connectivity; then
		echo -e "   Network \033[0;32m Good \033[0;0m"
	else
		echo -e "   Network \033[0;31m Error \033[0;0m"
		end " Please check your network connection and try again."
	fi

	if check_efi; then
		echo -e "   EFI     \033[0;32m Good \033[0;0m"
	else
		echo -e "   EFI     \033[0;31m Error \033[0;0m"
		end " You're not in EFI mode. Check your BIOS and try again."
	fi

	echo -e ""
	echo -e " Rice cooker configuration:"
	echo -e "   Locale"
	echo -e "     Timezone \033[0;36m $TIMEZONE \033[0;0m"
	echo -e "   Disk"
	echo -e "     Encrypt \033[0;36m $ENCRYPT \033[0;0m"
	echo -e "     Partitions"
	echo -e "     ├─boot \033[0;36m $SIZE_BOOT \033[0;0m"
	echo -e "     ├─swap \033[0;36m $SIZE_SWAP \033[0;0m"
	echo -e "     ├─root \033[0;36m $SIZE_ROOT \033[0;0m"
	echo -e "     └─home \033[0;36m $SIZE_HOME \033[0;0m"
	echo -e "   System"
	echo -e "     Username \033[0;36m $USERNAME \033[0;0m"
	echo -e "     Hostname \033[0;36m $HOSTNAME \033[0;0m"
	echo -e "   Defaults"
	echo -e "     WM/DE    \033[0;36m $WMDE     \033[0;0m"
	echo -e "     Launcher \033[0;36m $LAUNCHER \033[0;0m"
	echo -e "     Bar      \033[0;36m $BAR      \033[0;0m"
	echo -e "     Terminal \033[0;36m $TERMINAL \033[0;0m"
	echo -e "     Editor   \033[0;36m $EDITOR   \033[0;0m"
	echo -e "     Browser  \033[0;36m $BROWSER  \033[0;0m"
	echo -e "   Drivers"
	echo -e "     Display \033[0;36m $DRIVERS \033[0;0m"
	echo -e "   Dev Packs"
	echo -n "     "

	for (( i=0; i < ${#DEV_PACKS[@]}-1; i++ )); do
		echo -en "\033[0;36m${DEV_PACKS[i]}\033[0;0m, "
	done

	echo -e "\033[0;36m${DEV_PACKS[i]}\033[0;0m"

	echo ""
	if confirm "Ready to install?"; then
		echo ""
		echo " Starting installation."
	else
		end " Aborting installation."
	fi

	tmux new-session \; split-window -h \; split-window -v \; attach \; \
		select-pane -t 0 \; send-keys -t 0 "sleep 0.1; sh rice-cooker.sh primary" Enter
}

if [[ "$func" == "" ]]; then
	main
elif [[ "$func" == "primary" ]]; then
	primary
elif [[ "$func" == "secondary" ]]; then
	secondary
elif [[ "$func" == "tertiary" ]]; then
	tertiary
else
	echo "Unknown input."
fi
