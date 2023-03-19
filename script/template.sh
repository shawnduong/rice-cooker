#!/bin/sh

# CLI arguments.
arg0="$1"

%% recipe %%

{{ include main.sh }}

if [[ "$arg0" == "" ]]; then
	main
else
	echo "Unknown input."
fi
