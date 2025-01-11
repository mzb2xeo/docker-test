#!/bin/bash
# 1/10/25 dev from /var/local/email_network_info.sh
# Script to gather system information and send it via email

# Get current date and time
datetime=$(date +"%A, %B %d, at %Y %H:%M:%S.")
echo "$datetime"

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

# Function to get network interfaces with IP addresses
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
if [ -n "$public_ip" ]; then
    echo "Public IP: $public_ip"
else
    echo "Failed to get public IP"
fi

#!/bin/bash

# Function to prompt for an email address
get_email() {
    read -p "Please enter your email address: " user_email
    echo $user_email
}

# Call the function and store the result in a variable
email=$(get_email)

# Output the captured email address
echo "You entered: $email"

# Construct email content
email_content="$datetime \nHostname: $hostname\nInternet Connection: $(ping -c 1 google.com &> /dev/null && echo 'OK' || echo 'None')\n$(get_ips)\nGateway: $gateway\nPublic IP: $public_ip"

 Email the collected information using mailx
echo -e "$email_content" | mailx -s "[$hostname] System Info Report" $email
