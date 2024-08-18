source setup.conf
source modules/common/flag.sh

# Synchronize the hardware clock. Flags 2008.
sync_hwclock()
{
	echo -n " Synchronizing hardware clock..."
	hwclock --systohc
	echo " done."
	flag 2008
}
