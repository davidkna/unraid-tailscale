#!/usr/bin/dumb-init /bin/sh

if [ ! -d /dev/net ]; then
    mkdir -p /dev/net
fi
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

exec \
    /usr/local/bin/tailscaled --help --state=/config/tailscaled.state