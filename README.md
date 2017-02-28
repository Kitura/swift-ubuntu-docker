[![Build Status - Develop](https://travis-ci.org/IBM-Swift/swift-ubuntu-docker.svg?branch=develop)](https://travis-ci.org/IBM-Swift/swift-ubuntu-docker)

# Swift 3 - Ubuntu v14.04 - Docker

This repo contains the code for generating two Docker images for Swift:

- The `ibmcom/swift-ubuntu` image contains the Swift 3.0.2 RELEASE toolchain as well as the dependencies for running Kitura-based applications. Our development team uses this image for development and testing of Swift 3 applications on the Linux Ubuntu (v14.04) operating system.
- The `ibmcom/swift-ubuntu-runtime` image contains only those libraries (`.so` files) provided by the Swift 3.0.2 RELEASE toolchain that are required to run Swift applications. Note that this image does not contain SwiftPM or any of the build tools used when compiling and linking Swift applications. Hence, the size for the `ibmcom/swift-ubuntu-runtime` image (~300 MB) is much smaller than that of the `ibmcom/swift-ubuntu` image. The `ibmcom/swift-ubuntu-runtime` image is ideal for provisioning your Swift application as an [IBM Container](https://www.ibm.com/cloud-computing/bluemix/containers) on Bluemix.

# Recent updates
1. Reduced number of layers in images.
2. Removed system packages no longer needed.
3. Upgraded to the Swift 3.0.2 RELEASE binaries.
4. Aligned version of Ubuntu with version found in Cloud Foundry environments (v14.04).
5. Reduced size of the Docker image.
6. Updated Dockerfiles per guidelines in [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

# ibmcom/swift-ubuntu
## Pulling ibmcom/swift-ubuntu from Docker Hub
Run the following command to download the latest version of the `ibmcom/swift-ubuntu` image from Docker Hub:

```
docker pull ibmcom/swift-ubuntu:latest
```

## Using ibmcom/swift-ubuntu for development
Mount a folder on your host to your Docker container using the following command:

```
docker run -i -t -v <absolute path to the swift package>:/root/<swift package name> ibmcom/swift-ubuntu:latest
```

After executing the above command, you will have terminal access to the Docker container (the default command for the image is `/bin/bash`). This will allow you to build, test, and run your Swift application in a Linux environment (Ubuntu v14.04).

## Privileged mode
If you attempt to run the Swift REPL and you get the error `failed to launch REPL process: process launch failed: 'A' packet returned an error: 8`, then you should run your Docker container in privileged mode:

```
docker run --privileged -i -t ibmcom/swift-ubuntu:latest
```

This issue is described at https://bugs.swift.org/browse/SR-54.

# ibmcom/swift-ubuntu-runtime
## Pulling ibmcom/swift-ubuntu-runtime from Docker Hub
Run the following command to download the latest version of the `ibmcom/swift-ubuntu-runtime` image from Docker Hub:

```
docker pull ibmcom/swift-ubuntu-runtime:latest
```

## Using ibmcom/swift-ubuntu-runtime
You can extend the `ibmcom/swift-ubuntu-runtime` image in your own Dockerfile to add your Swift application binaries (and any other dependencies you may need). For instance, the next sample Dockerfile simply adds the binaries for the [Kitura-Starter](https://github.com/IBM-Bluemix/Kitura-Starter) application and specifies the command to start the server (total image size after adding the Kitura-Starter binaries is ~300MB):

```
# Builds a Docker image for running the Kitura-Starter sample application.

...

FROM ibmcom/swift-ubuntu-runtime:latest
LABEL Description="Docker image for running the Kitura-Starter sample application."

USER root

# Expose default port for Kitura
EXPOSE 8080

# Binaries should have been compiled against the correct platform (i.e. Ubuntu 14.04).
RUN mkdir /root/Kitura-Starter
ADD .build/debug/Kitura-Starter /root/Kitura-Starter
ADD .build/debug/*.so /root/Kitura-Starter
CMD [ "sh", "-c", "/root/Kitura-Starter/Kitura-Starter" ]
```

For details on how to create an IBM Container to execute a Swift application, please see [10 Steps To Running a Swift App in an IBM Container] (https://developer.ibm.com/swift/2016/02/22/10-steps-to-running-a-swift-app-in-an-ibm-container) and [Running Kitura in an IBM Container](https://developer.ibm.com/swift/2016/03/04/running-kitura-in-an-ibm-container/).

# Exposing ports in your Docker container
Exposing your server's port running in a Docker container to the host system (e.g. macOS) is quite easy using the latest version of Docker:

```
docker run -p <host port>:<container port> [additional options] <image name>
```

For example, if your Swift server is running on port `8080`, and you want to make it accessible via port `9080` on the host system, run the following command:

```
docker run -p 9080:8080 [additional options] <image name>
```

Port `8080` in the container will then be mapped to port `9080` on the host system. For further details on the `-p` option, see the official Docker [documentation](https://docs.docker.com/engine/reference/run/#/expose-incoming-ports).
