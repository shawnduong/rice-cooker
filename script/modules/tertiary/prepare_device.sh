source setup.conf
source modules/common/flag.sh

# Partition, format, mount, etc. the device. Flags from [3000,3008].
prepare_device()
{
	# Partition the disk.

	read -r -p " Awaiting device from controller... " device
	sgdisk -o "/dev/$device" >/dev/null

	echo -n " Creating boot partition..."
	sgdisk --new "0:0:+$SIZE_BOOT" -t 0:ef00 "/dev/$device" >/dev/null
	echo " done."

	echo -n " Creating lvm partition..."
	sgdisk --new "0:0:0" -t 0:8e00 "/dev/$device" >/dev/null
	echo " done."

	flag 3000

	if [[ "$device" == "nvme*" ]]; then
		devBoot="/dev/${device}p1"
		devLvm="/dev/${device}p2"
	else
		devBoot="/dev/${device}1"
		devLvm="/dev/${device}2"
	fi

	# Format the boot partition.

	echo -n " Formatting the boot partition..."
	mkfs.fat -F32 "$devBoot" >/dev/null
	echo " done."
	stty -echo
	flag 3001

	# Format the LVM partition.

	read -r -p " Awaiting encryption key from controller..." encKey
	echo " [hidden]"
	stty echo

	modprobe dm-crypt

	echo -n " Formatting the LVM partition..."
	echo -n "$encKey" | cryptsetup -q luksFormat "$devLvm"
	echo " done."
	flag 3002

	# Partition the LVM partition.

	echo -n " Opening the LVM partition..."
	echo -n "$encKey" | cryptsetup open --type luks "$devLvm" lvm >/dev/null
	echo " done."

	pvcreate /dev/mapper/lvm >/dev/null
	vgcreate vg0 /dev/mapper/lvm >/dev/null
	echo -n " Creating swap..."
	lvcreate -L "$SIZE_SWAP" vg0 -n swap >/dev/null
	echo " done."

	echo -n " Creating root..."
	lvcreate -L "$SIZE_ROOT" vg0 -n root >/dev/null
	echo " done."

	echo -n " Creating home..."
	if [[ "$SIZE_HOME" == "remainder" ]]; then
		lvcreate -l 100%FREE vg0 -n home >/dev/null
	else
		lvcreate -L "$SIZE_HOME" vg0 -n home >/dev/null
	fi
	echo " done."

	flag 3003

	# Make the swap.

	echo -n " Making swap..."
	mkswap /dev/vg0/swap >/dev/null
	echo " done."
	flag 3004

	# Format root.

	echo -n " Formatting root..."
	mkfs.ext4 -q /dev/vg0/root
	echo " done."
	flag 3005

	# Format home.

	echo -n " Formatting home..."
	mkfs.ext4 -q /dev/vg0/home
	echo " done."
	flag 3006

	# Mount everything.

	echo -n " Mounting root..."
	mount /dev/vg0/root /mnt
	echo " done."

	echo -n " Mounting boot..."
	mkdir /mnt/boot /mnt/home
	mount "$devBoot" /mnt/boot
	echo " done."

	echo -n " Mounting home..."
	mount /dev/vg0/home /mnt/home
	echo " done."

	flag 3007

	# Enable swap.

	echo -n " Enabling swap..."
	swapon /dev/vg0/swap
	echo " done."
	flag 3008
}
