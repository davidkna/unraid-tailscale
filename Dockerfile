# Portions Copyright (c) 2020 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM alpine AS builder

WORKDIR /go/src/tailscale

RUN apk add --no-cache bash curl ca-certificates jq
RUN URL="https://pkgs.tailscale.com/stable/$(curl -fssL https://pkgs.tailscale.com/stable/ | grep amd64.tgz | cut -f2 -d\")" && \
    curl -fLo /tmp/tailscale-src.tar.gz "$URL" && \
    mkdir -p /tmp/tailscale && \
    tar xvf /tmp/tailscale-src.tar.gz -C /tmp/tailscale --strip-components=1

FROM alpine
RUN apk add --no-cache ca-certificates iptables iproute2 tzdata dumb-init
COPY --from=builder /tmp/tailscale/tailscale /tmp/tailscale/tailscaled /usr/local/bin/
COPY ./entry.sh /usr/local/bin/entry.sh

VOLUME /config

CMD [ "/usr/local/bin/entry.sh" ]
