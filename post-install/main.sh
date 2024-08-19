#!/bin/bash

main()
{
	echo "┌───────────────────────────┐"
	echo "│        RICE COOKER        │"
	echo "│          by skat          │"
	echo "└───────────────────────────┘"

	echo -e "\n Welcome to your new barebones Arch install!"
	echo -e "\n This post-install script will execute the following modules:"

	for module in "./enabled/*.sh"; do
		echo $module
	done
}

main
