FROM quay.io/lib/ubuntu:24.04

LABEL org.opencontainers.image.title="Squid 6 Proxy" \
      org.opencontainers.image.description="Squid 6 Proxy image built on Ubuntu 24.04" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/landregistry/docker-base-images/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/landregistry/docker-base-images" \
      org.opencontainers.image.vendor="HM Land Registry"

ARG SQUID_RELEASE=SQUID_6_13
ARG SQUID_VERSION=squid-6.13

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_SSLDB_DIR=/var/lib/ssl_db \
    SQUID_USER=proxy \
    SQUID_GROUP=root

WORKDIR /tmp

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends ca-certificates=20240203 g++=4:13.2.0-7ubuntu1 make=4.3-4.1build2 libssl-dev=3.0.13-0ubuntu3.5 pkg-config=1.8.1-2build1 wget=1.21.4-1ubuntu4.1 \
 && rm -rf /var/lib/apt/lists/* \
 && update-ca-certificates -f \
 && wget -q https://github.com/squid-cache/squid/releases/download/${SQUID_RELEASE}/${SQUID_VERSION}.tar.gz \
 && tar xzf ${SQUID_VERSION}.tar.gz

WORKDIR /tmp/${SQUID_VERSION}

RUN ./configure --enable-ssl-crtd --with-openssl --prefix=/usr --localstatedir=/var --libexecdir="\${prefix}/lib/squid" --datadir="\${prefix}/share/squid" --sysconfdir=/etc/squid --with-default-user=proxy --with-logdir=/var/log/squid --with-pidfile=/var/run/squid.pid \
 && make -s install

WORKDIR /tmp

RUN rm -rf ${SQUID_VERSION} && rm ${SQUID_VERSION}.tar.gz \
 && wget -q https://github.com/krallin/tini/releases/download/v0.19.0/tini -O /tini \
 && chmod +x /tini \
 && usermod -a -G ${SQUID_GROUP} ${SQUID_USER}

COPY squid.conf ssl.pem entrypoint.sh /etc/squid/

EXPOSE 3128/tcp
VOLUME /var/spool/squid

# Set Tini entrypoint
ENTRYPOINT ["/tini", "-e", "143", "--"]

# Set squid CMD
CMD ["bash", "/etc/squid/entrypoint.sh"]
