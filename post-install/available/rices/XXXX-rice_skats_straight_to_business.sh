#!/bin/bash

rice="skats_straight_to_business"

echo " Installing fonts..."
pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
	ttf-liberation ttf-dejavu ttf-roboto \
	ttf-jetbrains-mono ttf-fira-code ttf-hack adobe-source-code-pro-fonts
echo " Fonts installed."

echo " Installing prerequisite packages..."
pacman -S --noconfirm xorg xorg-xinit xterm i3 wget
echo " Prerequisite packages installed."

username="$(cat /etc/passwd | grep /home/ | awk -F ':' '{print $1}')"

echo " Installing packages..."
pacman -S --noconfirm picom polybar rofi unclutter xclip feh scrot flameshot xss-lock
echo " packages installed."

echo -n " Configuring X to auto-start i3..."
echo "exec i3" > "/home/$username/.xinitrc"
echo " done."
chown "$username:" "/home/$username/.xinitrc"

echo -n " Copying bash profile..."
cp "configs/$rice/bash-profile" "/home/$username/.bash_profile"
chown "$username:" "/home/$username/.bash_profile"
echo " done."

echo -n " Copying bashrc..."
cp "configs/$rice/bash-config" "/home/$username/.bashrc"
chown "$username:" "/home/$username/.bashrc"
echo " done."

echo -n " Copying i3 config..."
mkdir -p "/home/$username/.config/i3/"
cp "configs/$rice/i3-config" "/home/$username/.config/i3/config"
chown -R "$username:" "/home/$username/.config/i3/"
echo " done."

echo -n " Copying picom config..."
mkdir -p "/home/$username/.config/picom/"
cp "configs/$rice/picom-config" "/home/$username/.config/picom/picom.conf"
chown -R "$username:" "/home/$username/.config/picom/"
echo " done."

echo -n " Copying polybar config..."
mkdir -p "/home/$username/.config/polybar/"
cp "configs/$rice/polybar-config" "/home/$username/.config/polybar/config"
chown -R "$username:" "/home/$username/.config/polybar/"
echo " done."

echo -n " Copying rofi config..."
mkdir -p "/home/$username/.config/rofi/"
cp "configs/$rice/rofi-config" "/home/$username/.config/rofi/config.rasi"
chown -R "$username:" "/home/$username/.config/rofi/"
echo " done."

echo -n " Copying vim config..."
cp "configs/$rice/vim-config" "/home/$username/.vimrc"
chown "$username:" "/home/$username/.vimrc"
echo " done."

echo -n " Copying wallpapers..."
mkdir -p "/home/$username/pic/wallpapers/"
cp -r "configs/$rice/wallpapers/" "/home/$username/pic/"
chown -R "$username:" "/home/$username/pic/wallpapers/"
echo " done."

echo -n " Copying custom sh utilities..."
cp -r "configs/$rice/sh/" "/home/$username/"
chown -R "$username:" "/home/$username/sh/"
echo " done."

echo -n " Installing vim Plug manager..."
mkdir -p "/home/$username/.vim/autoload/"
wget -q "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -P "/home/$username/.vim/autoload/"
chown -R "$username:" "/home/$username/.vim"
echo " done."

echo " Installing st..."
git clone https://github.com/bakkeby/st-flexipatch "/home/$username/sh/programs/st-flexipatch/st/" >/dev/null
chown -R "$username:" "/home/$username/sh/programs/"
su $username bash -c "cd ~/sh/programs/st-flexipatch/st/ && cp ../*.h ../*.mk ./ && make"
cp "/home/$username/sh/programs/st-flexipatch/st/st" "/usr/local/bin/"
chmod 755 "/usr/local/bin/st"
echo " st installed."

echo " Installing i3lock-color..."
pacman -Rs --noconfirm i3lock
sudo su $username bash -c "yay -S --noconfirm i3lock-color"
echo " i3lock-color installed."

echo "A few notes:"
echo " - You may need to edit the polybar config and specify where your heat sensor is"
echo "   as well as what network interface to monitor."
echo " - Open up vim and run :PlugInstall. The color plugin won't work until then."
echo " - If your system supports it, enable picom in the i3 config."
echo " - If you have dual monitors, lock a workspace to it in the i3 config."
echo " - If you have dual monitors, kill polybar and any other program and take a full"
echo "   screenshot with scrot. Name this 'wallpaper_combined' and put it in"
echo "   ~/sh/wallpapers. This will show the wallpaper when you lock the computer."
echo " - The lockscreen is made for 1920x1080 screens. You may need to tweak it for"
echo "   other size screens."
