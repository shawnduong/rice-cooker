source setup.conf
source modules/common/flag.sh

# Update /etc/hosts. Flags 2010.
set_hostname()
{
	echo -n " Adding localhost self to hosts..."
	echo "" >> /etc/hosts
	echo "127.0.0.1  $HOSTNAME.net  $HOSTNAME" >> /etc/hosts
	echo "::1        $HOSTNAME.net  $HOSTNAME" >> /etc/hosts
	echo " done."
	flag 2010
}
