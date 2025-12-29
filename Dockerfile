FROM golang:1.17-alpine

RUN apk add ca-certificates

WORKDIR /go/src/github.com/pierre-emmanuelJ/iptv-proxy
COPY . .
RUN GO111MODULE=off CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o iptv-proxy .

# Final stage - keep all GPU drivers
FROM docker.io/debian:bookworm-slim
# Install all GPU drivers + curl in one layer
    RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    #wget \
    #nano \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
FROM alpine:3
COPY --from=0  /go/src/github.com/pierre-emmanuelJ/iptv-proxy/iptv-proxy /
ENTRYPOINT ["/iptv-proxy"]
