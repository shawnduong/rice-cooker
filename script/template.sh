#!/bin/sh

# CLI arguments.
arg0="$1"

{{ include settings.sh }}

{{ include print_banner.sh }}

{{ include end.sh }}

{{ include confirm.sh }}

{{ include get_password.sh }}

{{ include checks.sh }}

{{ include flag.sh }}

{{ include check_connectivity.sh }}

{{ include check_efi.sh }}

{{ include get_format_device.sh }}

{{ include prepare_device.sh }}

{{ include install_essential_packages.sh }}

{{ include install_user_packages.sh }}

{{ include configure_bootloader.sh }}

{{ include primary.sh }}

{{ include secondary.sh }}

{{ include secondary_chroot.sh }}

{{ include tertiary.sh }}

{{ include tertiary_chroot.sh }}

{{ include main.sh }}

if [[ "$arg0" == "" ]]; then
	main
elif [[ "$arg0" == "primary" ]]; then
	primary
elif [[ "$arg0" == "secondary" ]]; then
	secondary
elif [[ "$arg0" == "secondary_chroot" ]]; then
	secondary_chroot
elif [[ "$arg0" == "tertiary" ]]; then
	tertiary
elif [[ "$arg0" == "tertiary_chroot" ]]; then
	tertiary_chroot
else
	echo "Unknown input."
fi
