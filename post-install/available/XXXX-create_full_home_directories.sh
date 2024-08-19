#!/bin/bash

echo " Installing prerequisite packages..."
pacman -S --noconfirm xdg-user-dirs
echo " Prerequisite packages installed."

echo -n " Creating full home directories..."

username="$(cat /etc/passwd | grep /home/ | awk -F ':' '{print $1}')"
su "$username" -c "xdg-user-dirs-update"

echo "done."
