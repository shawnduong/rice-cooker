#!/bin/sh

# CLI arguments.
arg0="$1"

%% recipe %%

# Tries to ping archlinux.org with 4 attempts.
# => 0 if able to, 1 if not.
_check_connectivity()
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
_check_efi()
{
	if ls /sys/firmware/efi/efivars &>/dev/null; then
		return 0
	fi

	return 1
}

main()
{
	echo "┌───────────────────────────┐"
	echo "│        RICE COOKER        │"
	echo "│       by shawnd.xyz       │"
	echo "│    (Early Development)    │"
	echo "└───────────────────────────┘"

	echo -n "   Network "
	if _check_connectivity; then
		echo -e "\033[0;32m Good \033[0;0m"
	else
		echo -e "\033[0;31m Error \033[0;0m"
		end " Please check your network connection and try again."
	fi

	echo -n "   EFI     "
	if _check_efi; then
		echo -e "\033[0;32m Good \033[0;0m"
	else
		echo -e "\033[0;31m Error \033[0;0m"
		end " You're not in EFI mode. Check your BIOS and try again."
	fi
}

if [[ "$arg0" == "" ]]; then
	main
else
	echo "Unknown input."
fi
