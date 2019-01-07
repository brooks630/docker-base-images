######################################################################
# Dockerfile to build Java Application Containers
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

# Explicitly expose the port set below
EXPOSE 8080

# ******* THE FOLLOWING ENV VARS WILL BE SET BY WEBOPS IN REAL ENVIRONMENTS *******

# The port for the server to listen on
ENV PORT 8080

# Will be used in real environments
ENV COMMIT LOCAL

# ******* END *******

# Install Java and zip file support
# Also install make so the makefile can be used
RUN yum -q -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel unzip wget which make --setopt=tsflags=nodocs && \
  yum -q -y clean all

# Make sure downloaded dependencies go into a volume so it will persist between
# container restarts, speeding future builds up
RUN mkdir -p /opt/gradle/.gradle
ENV GRADLE_USER_HOME /opt/gradle/.gradle
VOLUME ["/opt/gradle"]

# Default directory to run the app from
WORKDIR /src

# Add Tini
RUN curl -L https://github.com/krallin/tini/releases/download/v0.18.0/tini > /tini && \
 chmod +x /tini
ENTRYPOINT ["/tini", "-e", "143", "--"]

# The command creates a jar then runs it to prevent gradle running in the background using hundreds of megs of ram.
# And be closer to how it's run in reality.
# No hot reload though. Override it if you need to.
# Any apps that use this as a base must import the shadowjar plugin into the build.gradle
CMD ./gradlew shadowJar --no-daemon && exec java -jar $(find /src/build/libs -name '*.jar' | head -1)

