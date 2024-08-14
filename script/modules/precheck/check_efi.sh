# Checks if the system is EFI.
# => 0 if so, 1 if not.
check_efi()
{
	if ls /sys/firmware/efi/efivars &>/dev/null; then
		return 0
	fi

	return 1
}
