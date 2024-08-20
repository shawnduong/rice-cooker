# Clean up the base install files. Flags 2051.
cleanup()
{
	echo -n " Cleaning up files..."
	rm -rf /mnt/root/setup/
	flag 2051
	echo " done."
}
