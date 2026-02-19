############################
# BUILD
############################
FROM debian:13-slim AS builder
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        ca-certificates \
        pkg-config \
        wget \
        curl \
        make && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone --depth=1 https://github.com/TelegramMessenger/MTProxy.git

WORKDIR /build/MTProxy

RUN make -j$(nproc)

############################
# RUNTIME
############################
FROM debian:13-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl3 \
        zlib1g \
        ca-certificates \
        netcat-openbsd \
        curl && \
    rm -rf /var/lib/apt/lists/* 

RUN useradd -r -s /usr/sbin/nologin mtproxy

WORKDIR /opt/mtproxy

# Копируем бинарник
COPY --from=builder /build/MTProxy/objs/bin/mtproto-proxy .
RUN mkdir /data && \
    curl -s https://core.telegram.org/getProxySecret -o /data/proxy-secret && \
    curl -s https://core.telegram.org/getProxyConfig -o /data/proxy-multi.conf && \
    chown -R mtproxy:mtproxy /data

RUN chown -R mtproxy:mtproxy /opt/mtproxy

USER mtproxy

EXPOSE 443 8888

ENTRYPOINT ["./mtproto-proxy"]
