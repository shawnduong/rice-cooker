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
