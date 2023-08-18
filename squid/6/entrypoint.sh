#!/usr/bin/bash
set -e

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 775 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_GROUP} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chmod -R 775 ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_GROUP} ${SQUID_CACHE_DIR}
}

setup_ssl() {
  if [ ! -d "$SQUID_SSLDB_DIR" ]; then
    /usr/lib/squid/security_file_certgen -c -s ${SQUID_SSLDB_DIR} -M 4MB
    chmod -R 775 ${SQUID_SSLDB_DIR}
    chown -R ${SQUID_USER}:${SQUID_GROUP} ${SQUID_SSLDB_DIR}
  fi
}

create_log_dir
create_cache_dir
setup_ssl

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == $(which squid) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid) -N -f /etc/squid/squid.conf -z
  fi
  echo "Starting squid..."
  exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi