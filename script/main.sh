#!/bin/bash

source setup.conf
source modules/precheck/check_connectivity.sh
source modules/precheck/check_efi.sh
source modules/common/confirm.sh
source modules/common/end.sh

main()
{
	echo "┌───────────────────────────┐"
	echo "│        RICE COOKER        │"
	echo "│          by skat          │"
	echo "└───────────────────────────┘"

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
	echo -e "     Keyboard \033[0;36m $KEYBOARD \033[0;0m"
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
#	echo -e "     Directories \033[0;36m $DIRECTORIES \033[0;0m"
#	echo -e "   Defaults"
#	echo -e "     WM/DE      \033[0;36m $WMDE       \033[0;0m"
#	echo -e "     Compositor \033[0;36m $COMPOSITOR \033[0;0m"
#	echo -e "     Launcher   \033[0;36m $LAUNCHER   \033[0;0m"
#	echo -e "     Bar        \033[0;36m $BAR        \033[0;0m"
#	echo -e "     Terminal   \033[0;36m $TERMINAL   \033[0;0m"
#	echo -e "     Editor     \033[0;36m $EDITOR     \033[0;0m"
#	echo -e "     Lockscreen \033[0;36m $LOCKSCREEN \033[0;0m"
#	echo -e "     Wallpaper  \033[0;36m $WALLPAPER  \033[0;0m"
#	echo -e "     Browser    \033[0;36m $BROWSER    \033[0;0m"
#	echo -e "   Drivers"
#	echo -e "     Display \033[0;36m $DISPLAY \033[0;0m"
#	echo -e "     Wi-Fi   \033[0;36m $WIFI    \033[0;0m"
#	echo -e "   Dev Packs"
#	echo -n "     "

	echo ""
	if confirm "Ready to install?"; then
		echo -e "\n Starting installation."
	else
		end " Aborting installation."
	fi

	# Start termux with 3 panes, and start the primary.
	tmux new-session \; split-window -h \; split-window -v \; attach \; \
		select-pane -t 0 \; send-keys -t 0 "sleep 0.1; bash panes/primary.sh" Enter
}

main
