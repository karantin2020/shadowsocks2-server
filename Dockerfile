FROM golang:1.20.3-alpine3.17 AS builder

RUN apk add --no-cache --update git && apk add build-base

COPY . /src
WORKDIR /src

RUN go install github.com/shadowsocks/go-shadowsocks2@latest


FROM alpine:3.17.3

COPY --from=builder /go/bin/go-shadowsocks2 /app/ssocks2

WORKDIR /app

EXPOSE 443

HEALTHCHECK NONE

ENTRYPOINT ["./ssocks2", "-s", "ss://AEAD_CHACHA20_POLY1305:$SSERVER_KEY@:443"]

