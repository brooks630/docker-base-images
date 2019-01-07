# Base image Dockerfiles

There are four base Docker images that apps can extend from: Python, Flask (extended from python), Java and Ruby. They are pulled down from the [Docker Hub](https://hub.docker.com/u/hmlandregistry/) when app images are built that use them in a FROM.

They extend CentOS and contain some preinstalled packages and environment variables, to provide some level of consistency with the proper HMLR infrastructure and allow for consistency between applications.

## Making changes

Changes must be pushed to the Docker Hub. The general process is this:

1. Pull down this repo.
2. Create a new version - a whole new Dockerfile, placed in a new directory. Whether it should be a major or minor version change depends on how fundamental the changes are e.g. language version vs environment variables vs supplementary packages.
3. Update the Changelog file.
4. Commit and push the changes to this repo.
5. Build the changed images, tagging them with the appropriate version number (and, if it is the highest version number, the "latest" tag as well - although you may want to wait a couple of days for testing before doing this). To maximise layer sharing, try to build new versions of different base images at the same time.
6. Push the changed images/tags to Docker Hub (including "latest" if you have built that tag)
7. Update the Docker Hub description with new Dockerfile links as necessary.

### Example commands

```shell
docker build -t hmlandregistry/dev_base_python:5 https://github.com/LandRegistry/docker-base-images.git#:dev_base_python/5
docker tag hmlandregistry/dev_base_python:5 hmlandregistry/dev_base_python:latest
docker push hmlandregistry/dev_base_python:latest
docker push hmlandregistry/dev_base_python:5
```