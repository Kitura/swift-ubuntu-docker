##
# Copyright IBM Corporation 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

# Dockerfile to build a Docker image with the latest Swift binaries and its
# dependencies.

FROM ubuntu:15.10
MAINTAINER Mobile Innovation Lab (IBM)
LABEL Description="Image to create a Linux environment with the latest Swift binaries."

# Variables
ENV SWIFT_SNAPSHOT swift-DEVELOPMENT-SNAPSHOT-2016-02-08-a
ENV UBUNTU_VERSION ubuntu15.10
ENV UBUNTU_VERSION_NO_DOTS ubuntu1510
ENV HOME /root
ENV WORK_DIR /root

# Set WORKDIR
WORKDIR ${WORK_DIR}

# Linux OS dependencies
RUN apt-get update
RUN apt-get install -y libhttp-parser-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y gcc-4.8
RUN apt-get install -y g++-4.8
RUN apt-get install -y libcurl3
RUN apt-get install -y libhiredis-dev
RUN apt-get install -y libkqueue-dev
RUN apt-get install -y openssh-client
RUN apt-get install -y automake
RUN apt-get install -y libbsd-dev
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y libtool
RUN apt-get install -y clang
RUN apt-get install -y curl
RUN apt-get install -y libglib2.0-dev
RUN apt-get install -y libblocksruntime-dev
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y telnet

# Install Swift compiler
RUN wget https://swift.org/builds/development/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
RUN tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
ENV PATH $WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH
RUN swiftc -h

# Clone and install libdispatch
#RUN git clone https://github.com/apple/swift-corelibs-libdispatch.git
# Using forked version as an interim solution (pull request in progress)
RUN git clone -b opaque-pointer git://github.com/seabaylea/swift-corelibs-libdispatch
RUN cd swift-corelibs-libdispatch && sh ./autogen.sh && ./configure && make && make install

# Add module map file for libdispatch
ADD module.modulemap /usr/local/include/dispatch
