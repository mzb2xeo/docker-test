#!/bin/bash
#1/5/25 Production email.network_info.sh
# Get current date and time
current_date_time=$(date +"%A, %B %d, at %Y %H:%M:%S.")
echo "Current Date & Time: $current_date_time"
# Check internet connectivity
if ping -c 1 google.com &> /dev/null; then
    echo "Internet connection is OK"
else
    echo "No internet connection"
fi
# Get hostname and gateway
hostname=$(uname -n)
gateway=$(ip route show default | awk '{print $3}')
echo "Hostname: $hostname"
echo "Gateway: $gateway"
# Get network interfaces with IP addresses

get_ips() {
    if ip addr show &> /dev/null; then
        echo "Interfaces with IP addresses:"
        ip -o -4 addr list | awk '{print $2, "=>", $4}'
    elif ifconfig -a &> /dev/null; then
        echo "Listing network interfaces with IP addresses:"
        ifconfig -a | grep 'inet ' | awk '{print $1, "=>", $2}'
    else
        echo "Neither 'ip' nor 'ifconfig' command found. Please install one."
        exit 1
    fi
}
get_ips

# Get public IP using curl
public_ip=$(curl -s https://api.ipify.org)
if [ "$public_ip" != "" ]; then
    echo "Public IP: $public_ip"
else
    echo "Failed to get public IP"
fi
# Construct email content
email_content="$current_date_time\nHostname: $hostname\nInternet Connection: $(ping -c 1 google.com &> /dev/null && echo 'OK' || echo 'No')\n$(get_ips)\nGateway: $gateway\nPublic IP: $public_ip"
# Email the collected information using mailx
echo -e "$email_content" | mailx -s "$hostname System Info Report" michael@3mby.com
