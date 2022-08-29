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
