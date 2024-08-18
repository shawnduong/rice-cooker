source setup.conf
source modules/common/flag.sh

# Set the timezone. Flags 2007.
set_timezone()
{
	echo -n " Setting timezone..."
	ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
	echo " done."
	flag 2007
}
