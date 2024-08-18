# Enable NTP. Flags 2000.
enable_ntp()
{
	echo -n " Enabling NTP..."
	timedatectl set-ntp true
	echo " done."
	flag 2000
}
