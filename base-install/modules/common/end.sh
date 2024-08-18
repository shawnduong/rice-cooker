# Print an exit message and then quit.
# $1 = exit message
end()
{
	echo -e "\n$1"
	exit -1
}
