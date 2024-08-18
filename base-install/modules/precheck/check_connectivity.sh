# Tries to ping archlinux.org with 4 attempts.
# => 0 if able to, 1 if not.
check_connectivity()
{
	for i in {0..4}; do
		if ping -c 1 archlinux.org &>/dev/null; then
			return 0
		fi
	done

	return 1
}
