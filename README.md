# Squid

A Squid http proxy for use by apps in the common-dev-env. It contains a self signed SSL cert for HTTPS proxying also.

Dockerhub image is manually built (`cd squid/6 && docker build -t hmlandregistry/squid:6 .`).
GHCR image is automated by Github Actions (see `.github/workflows/publish-base-image.yml` for details).
