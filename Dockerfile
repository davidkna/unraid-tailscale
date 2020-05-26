# Portions Copyright (c) 2020 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM golang:alpine AS builder

WORKDIR /go/src/tailscale

RUN apk add bash curl ca-certificates jq
RUN DL_URL=$(curl -ssfL \
    "https://api.github.com/repos/tailscale/tailscale/releases/latest" \
    | jq -r .tarball_url) && \
    mkdir -p /go/src/tailscale && \
    curl -fLo /tmp/tailscale-src.tar.gz "$DL_URL" && \
    tar xvf /tmp/tailscale-src.tar.gz -C /go/src/tailscale --strip-components=1 && \
    go mod download && \
    GOBIN=/usr/local/bin/ go install -v ./cmd/...


FROM lsiobase/alpine:latest
RUN apk add --no-cache ca-certificates iptables iproute2
COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY /root /

VOLUME /config
