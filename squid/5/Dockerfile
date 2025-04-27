FROM quay.io/lib/ubuntu:24.04

LABEL org.opencontainers.image.title="Squid 5 Proxy" \
      org.opencontainers.image.description="Squid 5 Proxy image built on Ubuntu 24.04" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/landregistry/docker-base-images/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/landregistry/docker-base-images" \
      org.opencontainers.image.vendor="HM Land Registry"

ARG TARGETARCH
ARG SQUID_VERSION=5.9

WORKDIR /tmp

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
      ca-certificates=20240203 \
      curl=8.5.0-2ubuntu10.6 \
      g++=4:13.2.0-7ubuntu1 \
      make=4.3-4.1build2 \
      libssl-dev=3.0.13-0ubuntu3.5 \
      pkg-config=1.8.1-2build1 \
 && rm -rf /var/lib/apt/lists/* \
 && update-ca-certificates -f \
 && curl -O http://www.squid-cache.org/Versions/v5/squid-${SQUID_VERSION}.tar.gz \
 && tar xzf squid-${SQUID_VERSION}.tar.gz \
 && ( \
      cd squid-${SQUID_VERSION} && \
      ./configure --enable-ssl-crtd --with-openssl --prefix=/usr --localstatedir=/var \
          --libexecdir="\${prefix}/lib/squid" --datadir="\${prefix}/share/squid" \
          --sysconfdir=/etc/squid --with-default-user=proxy --with-logdir=/var/log/squid \
          --with-pidfile=/var/run/squid.pid && \
      make -s install \
    ) \
 && rm -rf squid-${SQUID_VERSION} && rm squid-${SQUID_VERSION}.tar.gz

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_SSLDB_DIR=/var/lib/ssl_db \
    SQUID_USER=proxy

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
  && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_SSLDB_DIR} \
  && echo "Adding tini..." \
  && curl -L https://github.com/krallin/tini/releases/download/v0.18.0/tini > /tini \
  && chmod +x /tini

EXPOSE 3128/tcp
VOLUME /var/spool/squid

# Set Tini entrypoint
ENTRYPOINT ["/tini", "-e", "143", "--"]

# Set squid CMD
CMD ["squid", "-f", "/etc/squid/squid.conf", "-NYd", "1"]