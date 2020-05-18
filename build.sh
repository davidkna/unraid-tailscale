#!/bin/bash

set -euxo pipefail

export GOBIN=/usr/local/bin/

VERSIONINFO=$(curl -ssfL "https://api.github.com/repos/tailscale/tailscale/releases/latest")
URL=$(echo "$VERSIONINFO" | jq -r .tarball_url)

mkdir -p /tmp/build
cd /tmp/build

curl -o /tmp/tailscale-src.tar.gz -L "$URL"
tar xvf /tmp/tailscale-src.tar.gz -C /tmp/build --strip-components=1

go mod download
go install -v ./cmd/...
