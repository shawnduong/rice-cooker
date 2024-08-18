source setup.conf
source modules/common/flag.sh

# Generate locale. Flags 3011.
generate_locale()
{
	echo -n " Generating locale..."
	echo "$LOCALE" >> /etc/locale.gen
	locale-gen &>/dev/null
	flag 3011
	echo " done."
}
