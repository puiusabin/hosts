#!/bin/bash

cat /etc/hosts | while read -r ip name; do
    if [[ -z "$ip" || "$ip" =~ ^# ]]; then
        continue
    fi

    current_ip=$(nslookup "$name" 2>/dev/null | awk '/^Address: / { print $2 }' | head -n 1)

    if [[ -z "$current_ip" ]]; then
        continue
    fi

    if [[ "$ip" != "$current_ip" ]]; then
        echo "Bogus IP for $name in /etc/hosts !"
    fi
done

