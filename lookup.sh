#!/bin/bash

validate_host_ip() {
    local hostname="$1"
    local expected_ip="$2"
    local dns_server="${3:-}"

    local nslookup_cmd="nslookup $hostname"
    if [[ -n "$dns_server" ]]; then
        nslookup_cmd+=" $dns_server"
    fi

    local current_ip=$(eval "$nslookup_cmd" 2>/dev/null | awk '/^Address: / { print $2 }' | head -n 1)

    if [[ -z "$current_ip" ]]; then
        return 1
    fi

    if [[ "$expected_ip" != "$current_ip" ]]; then
        echo "Bogus IP for $hostname in /etc/hosts !"
        return 1
    fi

    return 0
}

cat /etc/hosts | while read -r ip name; do
    if [[ -z "$ip" || "$ip" =~ ^# ]]; then
        continue
    fi

    validate_host_ip "$name" "$ip"
done
