source modules/common/flag.sh

# Enable NetworkManager so that networking works. Flags 2011.
enable_network()
{
	systemctl enable NetworkManager >/dev/null
	flag 2011
}
