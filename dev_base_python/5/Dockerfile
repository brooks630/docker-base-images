######################################################################
# Dockerfile to build Python Application Containers
# Based on CentOS
######################################################################
# Set the base image to Centos. NOTE: By not specifying the minor version, future rebuilds may download a more up to date image
FROM centos:centos7

# Set locale variables, this prevents UnicodeDecodeError and other random issues that might occur due to the lack of one
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'


# Install support for overlayfs (the default in docker 1.13+)
# Update system, despite a warning against this: https://docs.docker.com/articles/dockerfile_best-practices/#run
# The official CentOS Dockerfiles repo recommends it: https://github.com/CentOS/CentOS-Dockerfiles/blob/master/nginx/centos7/Dockerfile#L10
RUN yum -y -q install yum-plugin-ovl --setopt=tsflags=nodocs && \
  yum -q -y clean expire-cache && \
  yum -q -y update --setopt=tsflags=nodocs && \
  yum -q -y clean all

# Install dev tools to allow python modules with native code (like markupsafe) to compile
# Install IUS repo then install python3.4 and python34-devel (for psycopg2 etc)
# Declare a symbolic link for Python 3.4, to ensure that we can run it from the command 'python3'.
# Using --force in case the link already exists as we don't want the command to fail.
# Install pip via the PyPA bootstrap to ensure that it maps to pip3
RUN yum groups mark convert && \
  yum -q -y groupinstall "Development Tools" --skip-broken --setopt=tsflags=nodocs && \
  yum install -q -y https://repo.ius.io/ius-release-el7.rpm https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm  && \
  yum install -q -y python34 python34-devel --setopt=tsflags=nodocs && \
  ln -s /usr/bin/python3.4 /usr/bin/python3 --force && \
  yum -q -y clean all && \
  curl https://bootstrap.pypa.io/get-pip.py | python3

# Force stdin, stdout and stderr to be totally unbuffered
# Set the log level to DEBUG for development
ENV PYTHONUNBUFFERED=yes
