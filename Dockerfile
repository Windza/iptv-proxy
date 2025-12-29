FROM golang:1.24-alpine

RUN apk add ca-certificates

WORKDIR /app
COPY . .
RUN GO111MODULE=off CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o iptv-proxy .

FROM alpine:3
COPY --from=0  /app/iptv-proxy /
ENTRYPOINT ["/iptv-proxy"]
