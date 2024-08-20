source modules/common/flag.sh

# Enable NetworkManager so that networking works. Flags 2011.
enable_network()
{
	echo -n " Enabling networking..."
	systemctl enable NetworkManager >/dev/null 2>&1
	echo "done."
	flag 2011
}
