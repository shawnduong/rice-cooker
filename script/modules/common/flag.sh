# Mark a flag. If the terminal is chrooted, the controller should use
# check_chroot to find the flag.
# $1 = flag number
flag()
{
	touch "/tmp/$1"
}
