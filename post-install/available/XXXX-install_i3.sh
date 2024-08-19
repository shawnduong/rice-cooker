#!/bin/bash

echo " Installing prerequisite packages..."
pacman -S --noconfirm xorg xorg-xinit xterm i3
echo " Prerequisite packages installed."

username="$(cat /etc/passwd | grep /home/ | awk -F ':' '{print $1}')"

echo -n " Configuring X to auto-start i3..."
echo "exec i3" > /home/$username/.xinitrc
echo " done."

echo -n " Configuring Bash shell to automatically start X..."

echo "#"                                         > /home/$username/.bash_profile
echo "# ~/.bash_profile"                        >> /home/$username/.bash_profile
echo "#"                                        >> /home/$username/.bash_profile
echo ""                                         >> /home/$username/.bash_profile
echo "[[ -f ~/.bashrc ]] && . ~/.bashrc"        >> /home/$username/.bash_profile
echo ""                                         >> /home/$username/.bash_profile
echo "if systemctl -q is-active graphical.target && [[ ! \$DISPLAY && \$XDG_VTNR -eq 1 ]]; then" \
												>> /home/$username/.bash_profile
echo "	exec startx 1>/dev/null 2>&1"           >> /home/$username/.bash_profile
echo "fi"                                       >> /home/$username/.bash_profile

echo " done."
