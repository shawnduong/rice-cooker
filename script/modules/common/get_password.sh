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
