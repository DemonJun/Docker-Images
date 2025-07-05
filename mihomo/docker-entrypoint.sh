#!/bin/bash

set -e

CONFIG_FILE="/root/.config/mihomo/config.yaml"
CONFIG_DIR="/root/.config/mihomo"

mkdir -p "$CONFIG_DIR"
mkdir -p "/root/.config/mihomo/proxy_provider"

if [ ! -f "$CONFIG_FILE" ]; then
    cp /clash.yaml "$CONFIG_FILE"
fi

if [ -n "$url" ]; then
    sed -i "s|url: \"\"|url: \"$url\"|g" "$CONFIG_FILE"
fi

if [ -n "$filter" ]; then
    sed -i "s|Filter: &Filter \".*\"|Filter: \&Filter \"$filter\"|g" "$CONFIG_FILE"
fi

if [ -n "$ipv6" ]; then
    sed -i "s|ipv6: .*|ipv6: $ipv6|g" "$CONFIG_FILE"
fi

if [ -n "$udp" ]; then
    sed -i "s|udp: .*|udp: $udp|g" "$CONFIG_FILE"
fi

exec mihomo -d "$CONFIG_DIR"
