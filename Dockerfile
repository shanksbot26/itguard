# Multi-stage Dockerfile for ITGUARD
FROM golang:alpine AS builder

RUN apk add --no-cache git ca-certificates tzdata

WORKDIR /src

# Allow Go to fetch the required toolchain specified in go.mod
ENV GOTOOLCHAIN=auto

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build ITGUARD binary with embedded frontend
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w -X github.com/AdguardTeam/AdGuardHome/internal/version.version=v1.0.0 -X github.com/AdguardTeam/AdGuardHome/internal/version.channel=release" -o /bin/itguard ./main.go

# Stage 2: Final Minimal Runtime Image
FROM alpine:3.21

LABEL maintainer="ITGUARD Team" \
      org.opencontainers.image.title="ITGUARD" \
      org.opencontainers.image.description="Network-wide ads & trackers blocking DNS server"

RUN apk add --no-cache ca-certificates libcap tzdata && \
    mkdir -p /opt/itguard/conf /opt/itguard/work && \
    chown -R nobody:nogroup /opt/itguard

COPY --from=builder /bin/itguard /opt/itguard/itguard
RUN setcap 'cap_net_bind_service=+eip' /opt/itguard/itguard

EXPOSE 53/tcp 53/udp \
       67/udp 68/udp \
       80/tcp 443/tcp 443/udp \
       853/tcp 853/udp \
       3000/tcp 3000/udp \
       5443/tcp 5443/udp \
       6060/tcp

WORKDIR /opt/itguard/work
ENTRYPOINT ["/opt/itguard/itguard"]
CMD ["--no-check-update", "-c", "/opt/itguard/conf/AdGuardHome.yaml", "-w", "/opt/itguard/work"]
