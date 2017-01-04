[![Build Status - Develop](https://travis-ci.org/IBM-Swift/swift-ubuntu-docker.svg?branch=develop)](https://travis-ci.org/IBM-Swift/swift-ubuntu-docker)

# Swift 3 - Ubuntu v14.04 - Docker

Docker image with the Swift 3.0.2 RELEASE binaries and dependencies for running Kitura-based applications. Our development team uses this image for development and testing of Swift 3 applications on the Linux Ubuntu (v14.04) operating system.

# Recent updates
1. Removed packages from Dockerfile no longer needed.
2. Upgraded Dockerfile to the Swift 3.0.2 RELEASE binaries.
3. Aligned version of Ubuntu with version found in Cloud Foundry environments (14.04).
4. Reduced size of the Docker image.
5. Updated Dockerfile per guidelines in [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

# Pull this image from Docker Hub
You can execute the following command to download the latest version of this image from Docker Hub:

```
docker pull ibmcom/swift-ubuntu:latest
```

# Using this image for development
You can mount a folder on your host to your Docker container using the following command:

```
docker run -i -t -v <absolute path to the swift package>:/root/<swift package name> ibmcom/swift-ubuntu:latest /bin/bash
```

After executing the above command, you will have terminal access to the Docker container.

# Privilege mode
If you attempt to run the Swift REPL and you get the error `failed to launch REPL process: process launch failed: 'A' packet returned an error: 8`, then you should run your Docker container in privilege mode:

```
docker run --privileged -i -t ibmcom/swift-ubuntu:latest  /bin/bash
```

This issue is described at https://bugs.swift.org/browse/SR-54.
