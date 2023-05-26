FROM ubuntu:22.04

ARG SQUID_VERSION=5.9

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y -q curl g++ make libssl-dev pkg-config \
 && rm -rf /var/lib/apt/lists/* \
 && curl -O http://www.squid-cache.org/Versions/v5/squid-${SQUID_VERSION}.tar.gz \
 && tar xzf squid-${SQUID_VERSION}.tar.gz \
 && cd squid-${SQUID_VERSION} \
 && ./configure --enable-ssl-crtd --with-openssl --prefix=/usr --localstatedir=/var --libexecdir=\${prefix}/lib/squid --datadir=\${prefix}/share/squid --sysconfdir=/etc/squid --with-default-user=proxy --with-logdir=/var/log/squid --with-pidfile=/var/run/squid.pid \
 && make install \
 && cd .. && rm -rf squid-${SQUID_VERSION} && rm squid-${SQUID_VERSION}.tar.gz

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