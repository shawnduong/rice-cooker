source modules/common/confirm.sh

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
