#!/bin/bash

# Enable 5 parallel downloads at a time.
cp /etc/pacman.conf /etc/pacman.conf.original
cat /etc/pacman.conf | sed -e "s/#ParallelDownloads = 5/ParallelDownloads = 5/" > /tmp/buffer
mv /tmp/buffer /etc/pacman.conf
