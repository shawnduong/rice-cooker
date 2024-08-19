#!/bin/bash

echo " Installing fonts..."
pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
	ttf-liberation ttf-dejavu ttf-roboto \
	ttf-jetbrains-mono ttf-fira-code ttf-hack adobe-source-code-pro-fonts
echo " Fonts installed."
