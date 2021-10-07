#!/bin/bash

# original idea

#If environment variable DEBUG is set to "true" bash debug will be set. Set Debug to "verbose" for more verbose debug information
if [ "${MY_DEBUG,,}" == "true" ]; then set -x ;elif [ "${MY_DEBUG,,}" == "verbose" ]; then set -xv; fi

set -euo pipefail
IFS=$'\n\t'

DEFAULT_IFACE=$(ip route | grep "default" | head -n 1 | cut -d ' ' -f 5)
INTERVAL=${INTERVAL:-5}

while true; do
      RX_PACKETS=$(cat /sys/class/net/${DEFAULT_IFACE}/statistics/rx_packets)
      RX_BYTES=$(cat /sys/class/net/${DEFAULT_IFACE}/statistics/rx_bytes)
      RX_ERRORS=$(cat /sys/class/net/${DEFAULT_IFACE}/statistics/rx_errors)

      TX_PACKETS=$(cat /sys/class/net/${DEFAULT_IFACE}/statistics/tx_packets)
      TX_BYTES=$(cat /sys/class/net/${DEFAULT_IFACE}/statistics/tx_bytes)
      TX_ERRORS=$(cat /sys/class/net/${DEFAULT_IFACE}/statistics/tx_errors)
      printf "{\"interface\" : \"${DEFAULT_IFACE}\",\"tx\": {\"packets\": \"${TX_PACKETS}\",\"bytes\": \"${TX_BYTES}\",\"errors\": \"${TX_ERRORS}\"},\"rx\": {\"packets\": \"${RX_PACKETS}\",\"bytes\": \"${RX_BYTES}\",\"errors\": \"${RX_ERRORS}\"}}"
    sleep $INTERVAL
done;
