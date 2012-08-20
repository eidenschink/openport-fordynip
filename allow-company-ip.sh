#!/bin/bash
#
# Tell the firewall (here: ufw managed) to allow SSH access
# from a certain IP that is looked up via DNS everytime
# the script runs.
#

PATH=/sbin:/bin:/usr/bin:/usr/sbin

# root or root-like perm (sudo) usually needed for ufw.
if [[ $(id -u) -ne 0 ]]; then
	echo "root permission required"
	exit 64
fi

# Enter the domain name with your specific IP 
# you probably manage by a service like dyn.com 
MYDNS=enter.your-domain.here

# File location where to store the changing IP addresses
# (to detect if changes are necessary and to remove an old rule)
CURRENT_IP_STORE=~/.myoldip

# Enter public IP of your server (machine running this script)
# Otherwise hopefully detected automatically (eth0 assumed)
#SERVERIP=123.123.123.123
SERVERIP=$(ifconfig eth0 | grep -i "inet ad" | awk -F: '{print $2}' | awk '{print $1}')

if [[ "$1" == "-init" ]]; then
	rm -f "$CURRENT_IP_STORE"
fi

test -f "$CURRENT_IP_STORE" || touch "$CURRENT_IP_STORE" || {
	echo "creating $CURRENT_IP_STORE failed."
	exit 65
}

# ask for the latest (probably cached) IP
LATESTIP=$(dig +short $MYDNS)

# fetch the current IP from our store
CURRENTIP=$(tail -1 $CURRENT_IP_STORE | awk '{print $1}')

if [[ "$LATESTIP" == "$CURRENTIP" ]]; then
	echo "nothing to do: ip is still $LATESTIP"
	exit 66
fi

if [ ! -z "$CURRENTIP" ]; then
	ufw delete allow from "$CURRENTIP" to "$SERVERIP" port 22
fi

DT=$(date +%d-%b-%Y-%H%M%S)
echo "${LATESTIP} ${DT}" >> "$CURRENT_IP_STORE"

ufw allow from "$LATESTIP" to "$SERVERIP" port 22

exit 0


