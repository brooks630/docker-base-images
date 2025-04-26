FROM quay.io/lib/ubuntu:24.04 AS base

LABEL org.opencontainers.image.title="Squid 6 Proxy" \
      org.opencontainers.image.description="Squid 6 Proxy image built on Ubuntu 24.04" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/landregistry/docker-base-images/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/landregistry/docker-base-images" \
      org.opencontainers.image.vendor="HM Land Registry"

# Common dependencies for build and run
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
      ca-certificates=20240203 \
      libssl-dev=3.0.13-0ubuntu3.5 \
 && rm -rf /var/lib/apt/lists/* \
 && update-ca-certificates -f

FROM base AS build

ARG SQUID_RELEASE=SQUID_6_13
ARG SQUID_VERSION=squid-6.13

WORKDIR /tmp

# Build-time only dependencies
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
      g++=4:13.2.0-7ubuntu1 \
      make=4.3-4.1build2 \
      pkg-config=1.8.1-2build1 \
      wget=1.21.4-1ubuntu4.1 \
 && rm -rf /var/lib/apt/lists/* \
 && wget -q https://github.com/squid-cache/squid/releases/download/${SQUID_RELEASE}/${SQUID_VERSION}.tar.gz \
 && tar xzf ${SQUID_VERSION}.tar.gz

WORKDIR /tmp/${SQUID_VERSION}

RUN ./configure --enable-ssl-crtd --with-openssl --prefix=/tmp/bin/squid --localstatedir=/var \
      --libexecdir="/usr/lib/squid" --datadir="/usr/share/squid" \
      --sysconfdir=/etc/squid --with-default-user=proxy --with-logdir=/var/log/squid \
      --with-pidfile=/var/run/squid.pid \
 && make --jobs --silent install \
 && wget -q https://github.com/krallin/tini/releases/download/v0.19.0/tini -O /tini

FROM base AS final

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_SSLDB_DIR=/var/lib/ssl_db \
    SQUID_USER=proxy \
    SQUID_GROUP=root

# Copy build files from build image to final image
COPY --from=build /tmp/bin/squid/bin /usr/bin
COPY --from=build /tmp/bin/squid/sbin /usr/sbin
COPY --from=build /tmp/bin/squid/share /usr/share
COPY --from=build /usr/lib/squid /usr/lib/squid
COPY --from=build /usr/share/squid /usr/share/squid
COPY --from=build /etc/squid /etc/squid
COPY --from=build --chown=${SQUID_GROUP}:${SQUID_USER} --chmod=755 /tini /tini

COPY squid.conf ssl.pem entrypoint.sh /etc/squid/

EXPOSE 3128/tcp
VOLUME /var/spool/squid

# Set Tini entrypoint
ENTRYPOINT ["/tini", "-e", "143", "--"]

# Set squid CMD
CMD ["bash", "/etc/squid/entrypoint.sh"]
