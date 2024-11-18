#!/bin/bash

validate_host_ip() {
    local hostname="$1"
    local expected_ip="$2"
    local dns_server="$3"

    local nslookup_cmd="nslookup $hostname"
    if [[ -n "$dns_server" ]]; then
        nslookup_cmd+=" $dns_server"
    fi

    local current_ip=$(eval "$nslookup_cmd" 2>/dev/null | awk '/^Address: / { print $2 }' | head -n 1)

    if [[ -z "$current_ip" ]]; then
        echo "Error: Cannot resolve hostname $hostname"
        return 1
    fi

    if [[ "$expected_ip" != "$current_ip" ]]; then
        echo "Mismatch: $hostname"
        echo "  Expected IP: $expected_ip"
        echo "  Current IP:  $current_ip"
        return 1
    fi

    echo "Hostname $hostname validated successfully"
    return 0
}

read -p "Enter hostname: " hostname
read -p "Enter IP address: " expected_ip
read -p "Enter DNS: " dns_server

validate_host_ip "$hostname" "$expected_ip" "$dns_server"
