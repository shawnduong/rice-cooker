#!/bin/bash

echo " Installing prerequisite packages..."
pacman -S --noconfirm xdg-user-dirs
echo " Prerequisite packages installed."

echo -n " Creating shortened home directories..."

username="$(cat /etc/passwd | grep /home/ | awk -F ':' '{print $1}')"
su "$username" -c "mkdir ~/doc/ ~/dl/ ~/mus/ ~/pic/ ~/doc/public/ ~/doc/templates/ ~/vid/"
su "$username" -c "xdg-user-dirs-update --set DESKTOP ~/"
su "$username" -c "xdg-user-dirs-update --set DOCUMENTS ~/doc/"
su "$username" -c "xdg-user-dirs-update --set DOWNLOAD ~/dl/"
su "$username" -c "xdg-user-dirs-update --set MUSIC ~/mus/"
su "$username" -c "xdg-user-dirs-update --set PICTURES ~/pic/"
su "$username" -c "xdg-user-dirs-update --set PUBLICSHARE ~/doc/public/"
su "$username" -c "xdg-user-dirs-update --set TEMPLATES ~/doc/templates/"
su "$username" -c "xdg-user-dirs-update --set VIDEOS ~/vid/"
su "$username" -c "xdg-user-dirs-update"

echo "done."
