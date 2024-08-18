# Mark a flag. If the terminal is chrooted, the controller should use
# check_chroot to find the flag.
# $1 = flag number
flag()
{
	touch "/tmp/$1"
}

# Same as above, but from non-chroot to chroot.
flag_chroot()
{
	touch "/mnt/tmp/$1"
}
