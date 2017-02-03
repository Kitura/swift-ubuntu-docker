[![Build Status - Develop](https://travis-ci.org/IBM-Swift/swift-ubuntu-docker.svg?branch=develop)](https://travis-ci.org/IBM-Swift/swift-ubuntu-docker)

# Swift 3 - Ubuntu v14.04 - Docker

This repo contains the code for generating two Docker images for Swift:

- The `ibmcom/swift-ubuntu` image contains the Swift 3.0.2 RELEASE toolchain as well as the dependencies for running Kitura-based applications. Our development team uses this image for development and testing of Swift 3 applications on the Linux Ubuntu (v14.04) operating system.
- The `ibmcom/swift-ubuntu-runtime` image contains only those libraries (`.so` files) provided by the Swift 3.0.2 RELEASE toolchain that are required to run Swift applications. Note that this image does not contain SwiftPM or any of the common build tools used when compiling and linking Swift applications. Hence, the size for the `ibmcom/swift-ubuntu-runtime` image (~300 MB) is much smaller than that of the `ibmcom/swift-ubuntu` image. The `ibmcom/swift-ubuntu-runtime` image is ideal for provisioning your Swift application as an [IBM Container](https://www.ibm.com/cloud-computing/bluemix/containers) on Bluemix.

# Recent updates
1. Reduced number of layers in images.
2. Removed packages from Dockerfiles no longer needed.
3. Upgraded Dockerfiles to the Swift 3.0.2 RELEASE binaries.
4. Aligned version of Ubuntu with version found in Cloud Foundry environments (v14.04).
5. Reduced size of the Docker image.
6. Updated Dockerfiles per guidelines in [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

# ibmcom/swift-ubuntu
## Pulling ibmcom/swift-ubuntu from Docker Hub
You can execute the following command to download the latest version of the `ibmcom/swift-ubuntu` image from Docker Hub:

```
docker pull ibmcom/swift-ubuntu:latest
```

## Using ibmcom/swift-ubuntu for development
You can mount a folder on your host to your Docker container using the following command:

```
docker run -i -t -v <absolute path to the swift package>:/root/<swift package name> ibmcom/swift-ubuntu:latest
```

After executing the above command, you will have terminal access to the Docker container (the default command for the image is `/bin/bash`). This will allow you to build, test, and run your Swift application in a Linux environment (Ubuntu v14.04).

## Privilege mode
If you attempt to run the Swift REPL and you get the error `failed to launch REPL process: process launch failed: 'A' packet returned an error: 8`, then you should run your Docker container in privilege mode:

```
docker run --privileged -i -t ibmcom/swift-ubuntu:latest /bin/bash
```

This issue is described at https://bugs.swift.org/browse/SR-54.

# ibmcom/swift-ubuntu-runtime
## Pulling ibmcom/swift-ubuntu from Docker Hub
You can execute the following command to download the latest version of the `ibmcom/swift-ubuntu-runtime` image from Docker Hub:

```
docker pull ibmcom/swift-ubuntu-runtime:latest
```

## Using ibmcom/swift-ubuntu-runtime
You can extend this image in your own Dockerfile and add your application binaries to it:

```
FROM swift-runtime:latest

...

# Install any additional system packages your Swift app may need
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y \
  <package-1> \
  <package-2> \

...

# Add your Swift application binaries
ADD .build/release <your-app-dir>

...

```

For details on how to create an IBM Container to execute a Swift application, please see [10 Steps To Running a Swift App in an IBM Container] (https://developer.ibm.com/swift/2016/02/22/10-steps-to-running-a-swift-app-in-an-ibm-container) and [Running Kitura in an IBM Container](https://developer.ibm.com/swift/2016/03/04/running-kitura-in-an-ibm-container/).
