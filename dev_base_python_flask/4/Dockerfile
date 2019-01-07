######################################################################
# Dockerfile to build Flask Application Containers
# Based on CentOS
######################################################################

# Set the base image
FROM hmlandregistry/dev_base_python:4

# Explicitly expose the port set below
EXPOSE 8080

# Disables sendfile in gunicorn to work around a caching bug with vagrant shared folders
ENV SENDFILE 0

# ******* THE FOLLOWING ENV VARS WILL BE SET BY WEBOPS IN REAL ENVIRONMENTS *******

# Added this environment variable so that pytest can import the application package.
ENV PYTHONPATH /src

# The port for gunicorn to listen on
ENV PORT 8080

# Will be used in real environments
ENV COMMIT LOCAL

# ******* END *******

WORKDIR /src

# Install gunicorn and eventlet
# When installing via IUS, gunicorn now goes to usr/bin
# Copy it to usr/local/bin for backwards compatibility in case anyone is using their own CMD
RUN pip3 -q install gunicorn==19.7.1 eventlet==0.21.0 && \
  cp /usr/bin/gunicorn /usr/local/bin/gunicorn

# The command to run the app.
#   Eventlet is used as the (asynch) worker.
#   The python source folder is /src (mapped to outside file system in docker-compose-fragment)
#   Access log is redirected to stderr.
#   Flask app object is located in manage.py
#   Dynamic reloading is enabled.
CMD ["/usr/bin/gunicorn", "-k", "eventlet", "--pythonpath", "/src", "--access-logfile", "-", "manage:manager.app", "--reload"]