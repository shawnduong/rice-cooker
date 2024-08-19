#!/bin/bash

echo -n " Enabling NTP..."
timedatectl set-ntp true
echo " done."
