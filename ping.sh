#!/bin/bash

clear
echo ""
cat << "EOF"
█▀█ █ █▄░█ █▀▀   █▀▄▀█ █▀▀
█▀▀ █ █░▀█ █▄█   █░▀░█ ██▄
EOF
echo ""
echo ""

# Ask the user for ping URL
read -p 'Enter URL: ' url
# Ask the user for delay in minutes
read -p 'Enter delay in minutes: ' delay
echo ""

# Convert delay to seconds
delay_in_seconds=$((delay * 60))

echo "Pinging $url every $delay minutes - Press Ctrl+C to stop"
echo ""

while true
do
    # Using -I for header, -s for silent mode, and --connect-timeout for timeout setting
    response=$(curl -Is --connect-timeout 5 $url)

    if [ $? -ne 0 ]; then
        echo "Failed to connect to $url"
    else
        status=$(echo "$response" | grep HTTP | head -1 | cut -d ' ' -f2)

        case $status in
            200) message="OK" ;;
            301|302) message="Redirected" ;;
            400) message="Bad Request" ;;
            401) message="Unauthorized" ;;
            403) message="Forbidden" ;;
            404) message="Not Found" ;;
            500) message="Internal Server Error" ;;
            *) message="Unknown status" ;;
        esac

        echo "Pinged! - $status $message"
    fi

    sleep $delay_in_seconds
done
