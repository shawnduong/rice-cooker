#!/bin/bash

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

# Print an exit message and then quit.
# $1 = exit message
end()
{
	echo -e "\n$1"
	exit -1
}

main()
{
	echo "┌───────────────────────────┐"
	echo "│        RICE COOKER        │"
	echo "│          by skat          │"
	echo "└───────────────────────────┘"

	echo -e "\n Welcome to your new barebones Arch install!"
	echo -e "\n This post-install script will execute the following modules:\n"

	for module in ./enabled/*.sh; do
		echo $module | awk -F '/' '{printf "   %s\n", $3}'
	done

	echo ""

	if confirm "Ready to run?"; then
		echo -e "\n Starting config."
	else
		end " Aborting installation."
	fi

	for module in ./enabled/*.sh; do
		shortname=$(echo $module | awk -F '/' '{print $3}')
		echo -e "\n---[ $shortname ]---"
		bash $module
	done
}

main
