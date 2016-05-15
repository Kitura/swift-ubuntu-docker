# Swift3 - Docker
Docker image with the Swift binaries (DEVELOPMENT-SNAPSHOT-2016-05-03-a)
and dependencies. Our development team uses this image for development
and testing of Swift applications on the Linux Ubuntu (v15.10) operating system.

# Branch Goals
The goal of this branch is to:
1. Reduce the size of the Docker image
1. Reduce the number of images in the container
1. Do not change any functionality
1. Follow best practices: https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

# Changes
1. Following apt-get best practices - single RUN, alphabetical listing
1. Dependencies which are nice-to-have have removed: vim, telnet
1. Dependencies added: libpython2.7

# Image Size Comparison
    swift3-docker        1.508 GB
    ibmcom/swift-ubuntu  1.765 GB
