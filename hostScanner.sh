#!/bin/bash

# Usage: ./check_hosts_up.sh <ip> <start_last_octet> <end_last_octet>
# Example: ./check_hosts_up.sh 192.168.1 1 254

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <ip> <start_last_octet> <end_last_octet>"
  echo "Example: $0 192.168.1 1 254"
  exit 1
fi

network_prefix=$1
start_last_octet=$2
end_last_octet=$3

# Function to check if a host is up using ARP
check_host() {
  local ip="$network_prefix.$1"
  arping -c 1 -w 1 $ip &>/dev/null && echo "$ip is up"
}



echo "Checking hosts in the range $network_prefix.$start_last_octet - $network_prefix.$end_last_octet..."

up_hosts=()
for octet in $(seq $start_last_octet $end_last_octet); do
  if check_host $octet; then
    up_hosts+=("$network_prefix.$octet")
  fi
done

echo "Finished checking hosts."

if [ ${#up_hosts[@]} -gt 0 ]; then
  echo "The following hosts are up:"
  printf "%s\n" "${up_hosts[@]}"
else
  echo "No hosts are up in the specified range."
fi
