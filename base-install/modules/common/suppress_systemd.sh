# Suppress systemd messages to console.
suppress_systemd()
{
	/usr/bin/kill -SIGRTMIN+21 1
}
