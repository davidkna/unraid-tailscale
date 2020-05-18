# Portions Copyright (c) 2020 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM golang:alpine AS builder

WORKDIR /go/src/tailscale

RUN apk add bash curl ca-certificates jq
COPY build.sh .
RUN bash build.sh

FROM lsiobase/alpine:latest
RUN apk add --no-cache ca-certificates iptables iproute2
COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY /root /

VOLUME /config
