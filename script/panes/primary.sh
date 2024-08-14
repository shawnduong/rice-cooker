#!/bin/bash

# Primary controller terminal. This is the left terminal. All flags originating
# from this terminal are 1xxx.
primary()
{
	# Start the scripts on the secondary and tertiary terminals.
	tmux send-keys -t 1 "bash panes/secondary.sh" Enter
	tmux send-keys -t 2 "bash panes/tertiary.sh" Enter
}

primary
