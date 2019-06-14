######################################################################
# Dockerfile to build NodeJS Application Containers
# Based on CentOS
######################################################################
# Set the base image to Centos. NOTE: By not specifying the minor version, future rebuilds may download a more up to date image
FROM centos:centos7

# Set locale to be en_GB, this prevents UnicodeDecodeError and other random issues that might occur due to the lack of one
RUN localedef -c -i en_GB -f UTF-8 en_GB.UTF-8
ENV LANG='en_GB.UTF-8' \
    LANGUAGE='en_GB:en' \
    LC_ALL='en_GB.UTF-8'

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

# Install support for overlayfs (the default in docker 1.13+)
# Update system, despite a warning against this: https://docs.docker.com/articles/dockerfile_best-practices/#run
# The official CentOS Dockerfiles repo recommends it: https://github.com/CentOS/CentOS-Dockerfiles/blob/master/nginx/centos7/Dockerfile#L10
RUN yum -y -q install yum-plugin-ovl --setopt=tsflags=nodocs && \
  yum -q -y clean expire-cache && \
  yum -q -y update --setopt=tsflags=nodocs && \
  yum -q -y clean all

# Install NodeJS
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms && \    
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum-config-manager --enable rhel-server-rhscl-8-rpms && \ 
    yum-config-manager --enable rhel-8-server-optional-rpms && \
    yum-config-manager --disable epel >/dev/null || : && \
    INSTALL_PKGS="rh-nodejs10 rh-nodejs10-nodejs-nodemon make gcc-c++" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y