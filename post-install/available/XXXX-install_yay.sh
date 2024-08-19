#!/bin/bash

echo " Installing yay..."

username="$(cat /etc/passwd | grep /home/ | awk -F ':' '{print $1}')"
pacman -S --noconfirm --needed git base-devel
su "$username" bash -c "cd /tmp && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && yes | makepkg -si"

echo " yay installed."
