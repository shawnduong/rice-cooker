#!/bin/sh

# Rice cooker settings.

TIMEZONE="US/Pacific"

ENCRYPT="Yes"
SIZE_BOOT="512M"
SIZE_SWAP="4G"
SIZE_ROOT="64G"
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
	while true
	do
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

	for (( i=0; i < ${#DEV_PACKS[@]}-1; i++ ))
	do
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

}

main
