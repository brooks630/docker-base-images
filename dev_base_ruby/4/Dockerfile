######################################################################
# Dockerfile to build Ruby Application Containers
# Based on CentOS
######################################################################
# Set the base image to Centos. NOTE: By not specifying the minor version, future rebuilds may download a more up to date image
FROM centos:centos7

# Set locale to be en_GB, this prevents UnicodeDecodeError and other random issues that might occur due to the lack of one
RUN localedef -c -i en_GB -f UTF-8 en_GB.UTF-8
ENV LANG='en_GB.UTF-8' \
    LANGUAGE='en_GB:en' \
    LC_ALL='en_GB.UTF-8'

# Install support for overlayfs (the default in docker 1.13+)
# Update system, despite a warning against this: https://docs.docker.com/articles/dockerfile_best-practices/#run
# The official CentOS Dockerfiles repo recommends it: https://github.com/CentOS/CentOS-Dockerfiles/blob/master/nginx/centos7/Dockerfile#L10
RUN yum -y -q install yum-plugin-ovl --setopt=tsflags=nodocs && \
  yum -q -y clean expire-cache && \
  yum -q -y update --setopt=tsflags=nodocs && \
  yum -q -y clean all

# Install rbenv/phantomjs system dependencies
RUN yum install -y -q gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel \
  openssl-devel make bzip2 autoconf automake libtool bison iconv-devel git-core wget fontconfig unzip

# Everything between here and the phantomjs install is shamelessly ripped from
# https://github.com/docker-library/ruby/blob/master/Dockerfile-debian.template
# and modified based on
# https://github.com/docker-library/ruby/blob/master/2.5/stretch/Dockerfile
# skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc
ENV RUBY_MAJOR=2.5 \
    RUBY_VERSION=2.5.3 \
    RUBY_DOWNLOAD_SHA256=1cc9d0359a8ea35fc6111ec830d12e60168f3b9b305a3c2578357d360fcf306f \
    RUBYGEMS_VERSION=2.7.8 \
	BUNDLER_VERSION=1.17.1 \
	GEM_HOME=/usr/local/bundle

ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"

ENV PATH $BUNDLE_BIN:$PATH

# some of ruby's build scripts are written in ruby
#   we purge system ruby later to make sure our final image uses what we just built
RUN set -ex \
	&& buildDeps=' \
		bison \
		libgdbm-dev \
		ruby \
	' \
	&& rm -rf /var/lib/apt/lists/* \
	&& wget -O ruby.tar.xz "https://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.xz" \
	&& echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.xz" | sha256sum -c - \
	&& mkdir -p /usr/src/ruby \
	&& tar -xJf ruby.tar.xz -C /usr/src/ruby --strip-components=1 \
	&& rm ruby.tar.xz \
	&& cd /usr/src/ruby \
	&& { \
		echo '#define ENABLE_PATH_CHECK 0'; \
		echo; \
		cat file.c; \
	} > file.c.new \
	&& mv file.c.new file.c \
	&& autoconf \
	&& ./configure --disable-install-doc \
	&& make -j"$(nproc)" \
	&& make install \
	&& cd / \
	&& rm -r /usr/src/ruby \
	&& gem update --system "$RUBYGEMS_VERSION" \
	&& gem install bundler --version "$BUNDLER_VERSION" --force \
	&& rm -r /root/.gem/ \
	&& mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

CMD [ "irb" ]

# Install ChromeDriver
RUN wget https://chromedriver.storage.googleapis.com/2.43/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/bin/ && \
	rm chromedriver_linux64.zip && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    yum install -y google-chrome-stable_current_x86_64.rpm && \
    rm google-chrome-stable_current_x86_64.rpm && \
	yum install -y -q fontconfig xorg-x11-fonts-Type1
