FROM quay.io/lib/ubuntu:24.04 AS base

LABEL org.opencontainers.image.title="Squid 5 Proxy" \
      org.opencontainers.image.description="Squid 5 Proxy image built on Ubuntu 24.04" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/landregistry/docker-base-images/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/landregistry/docker-base-images" \
      org.opencontainers.image.vendor="HM Land Registry"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
      ca-certificates=20240203 \
      libssl-dev=3.0.13-0ubuntu3.5 \
 && rm -rf /var/lib/apt/lists/* \
 && update-ca-certificates -f

FROM base AS build

WORKDIR /tmp

ARG SQUID_VERSION=5.9

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
      curl=8.5.0-2ubuntu10.6 \
      g++=4:13.2.0-7ubuntu1 \
      make=4.3-4.1build2 \
      pkg-config=1.8.1-2build1 \
 && curl -O http://www.squid-cache.org/Versions/v5/squid-${SQUID_VERSION}.tar.gz \
 && tar xzf squid-${SQUID_VERSION}.tar.gz

WORKDIR /tmp/squid-${SQUID_VERSION}

RUN ./configure --enable-ssl-crtd --with-openssl --prefix=/tmp/bin/squid --localstatedir=/var \
          --libexecdir="/usr/lib/squid" --datadir="/usr/share/squid" \
          --sysconfdir=/etc/squid --with-default-user=proxy --with-logdir=/var/log/squid \
          --with-pidfile=/var/run/squid.pid \
    && make --jobs --quiet install \
    && curl -L https://github.com/krallin/tini/releases/download/v0.18.0/tini > /tini

FROM base AS final

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_SSLDB_DIR=/var/lib/ssl_db \
    SQUID_USER=proxy

COPY --from=build /tmp/bin/squid/bin /usr/bin
COPY --from=build /tmp/bin/squid/sbin /usr/sbin
COPY --from=build /tmp/bin/squid/share /usr/share
COPY --from=build /usr/lib/squid /usr/lib/squid
COPY --from=build /usr/share/squid /usr/share/squid
COPY --from=build /etc/squid /etc/squid
COPY --from=build --chown=${SQUID_USER}:${SQUID_USER} --chmod=755 /tini /tini

COPY squid.conf /etc/squid/squid.conf
COPY ssl.pem /etc/squid/ssl.pem

RUN echo "Creating log directory..." \
  && mkdir -p ${SQUID_LOG_DIR} \
  && chmod -R 755 ${SQUID_LOG_DIR} \
  && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR} \
  && echo "Creating cache directory..." \
  && mkdir -p ${SQUID_CACHE_DIR} \
  && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR} \
  && echo "Initializing cache..." \
  && squid -N -f /etc/squid/squid.conf -z \
  && echo "Initializing SSL cert database..." \
  && /usr/lib/squid/security_file_certgen -c -s ${SQUID_SSLDB_DIR} -M 4MB \
  && echo "Setting SSL cert directory permissions..." \
  && chmod -R 755 ${SQUID_SSLDB_DIR} \
  && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_SSLDB_DIR}

EXPOSE 3128/tcp
VOLUME /var/spool/squid

# Set Tini entrypoint
ENTRYPOINT ["/tini", "-e", "143", "--"]

# Set squid CMD
CMD ["squid", "-f", "/etc/squid/squid.conf", "-NYd", "1"]