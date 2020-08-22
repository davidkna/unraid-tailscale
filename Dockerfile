# Portions Copyright (c) 2020 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM alpine AS builder

WORKDIR /go/src/tailscale

RUN apk add --no-cache bash curl ca-certificates jq
RUN VERSION=$(curl -ssfL \
    "https://api.github.com/repos/tailscale/tailscale/releases/latest" \
    | jq -r .tag_name \
    | sed 's/^v//') && \
    mkdir -p /tmp/tailscale && \
    curl -fLo /tmp/tailscale-src.tar.gz "https://pkgs.tailscale.com/stable/tailscale_${VERSION}_amd64.tgz" && \
    tar xvf /tmp/tailscale-src.tar.gz -C /tmp/tailscale --strip-components=1

FROM lsiobase/alpine:latest
RUN apk add --no-cache ca-certificates iptables iproute2 tzdata
COPY --from=builder /tmp/tailscale/tailscale /tmp/tailscale/tailscaled /usr/local/bin/
COPY ./root /

VOLUME /config
