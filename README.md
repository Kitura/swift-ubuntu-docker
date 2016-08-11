[![Build Status - Develop](https://travis-ci.org/IBM-Swift/swift-ubuntu-docker.svg?branch=develop)](https://travis-ci.org/IBM-Swift/swift-ubuntu-docker)

# Swift 3 - Ubuntu v14.04 - Docker

Docker image with the Swift binaries (DEVELOPMENT-SNAPSHOT-2016-07-25-a) and dependencies for running Kitura-based applications. Our development team uses this image for development and testing of Swift 3 applications on the Linux Ubuntu (v14.04) operating system.

# Recent updates
1. Aligned version of Ubuntu with version found in Cloud Foundry environments (14.04).
2. Reduced size of the Docker image.
3. Updated Dockerfile per guidelines in [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

# Privilege mode
If you attempt to run the Swift REPL and you get the error `failed to launch REPL process: process launch failed: 'A' packet returned an error: 8`, then you should run your Docker container in privilege mode:

```
docker run --privileged -i -t ibmcom/swift-ubuntu:latest  /bin/bash
```

This issue is described at https://bugs.swift.org/browse/SR-54.
