source setup.conf
source modules/common/flag.sh

# Set the hostname. Flags 2009.
set_hostname()
{
	echo -n " Setting hostname..."
	echo "$HOSTNAME" > /etc/hostname
	echo " done."
	flag 2009
}
