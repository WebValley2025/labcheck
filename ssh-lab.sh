#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <hostname> <ports>"
    echo "Example: $0 example.com '22,80,443'"
    exit 1
fi

HOSTNAME=$1
shift # Shift to remove the first argument, leaving only the ports

# Array to hold the ports
PORTS=("$@")

for PORT in "${PORTS[@]}"; do
    echo "Connecting to $HOSTNAME on port $PORT..."
    # echo ssh $HOSTNAME -p "$PORT" -N 
    # ssh -oStrictHostKeyChecking=no $HOSTNAME -p "$PORT" uptime &
    ssh -oStrictHostKeyChecking=no $HOSTNAME -p "$PORT" -N &

    # The & symbol runs the nc command in the background
    # This allows the script to continue and attempt to connect to the next port
done

echo "Connection attempts completed."
