##
# Copyright IBM Corporation 2016,2017
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

# Dockerfile to build a Docker image with the Swift tools and binaries and
# its dependencies.

FROM ibmcom/ubuntu:16.04
MAINTAINER IBM Swift Engineering at IBM Cloud
LABEL Description="Linux Ubuntu 16.04 image with the Swift binaries and tools."

USER root

# Set environment variables for image
ARG VERSION=${VERSION}
ENV SWIFT_SNAPSHOT swift-${VERSION}-RELEASE
ENV SWIFT_SNAPSHOT_LOWERCASE swift-${VERSION}-release
ENV UBUNTU_VERSION ubuntu16.04
ENV UBUNTU_VERSION_NO_DOTS ubuntu1604
ENV WORK_DIR /

# Set WORKDIR
WORKDIR ${WORK_DIR}

# Linux OS utils and libraries and set clang 3.8 as default
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y \
  build-essential \
  clang-3.8 \
  git \
  libpython2.7 \
  libicu-dev \
  wget \
  libcurl4-openssl-dev \
  openssl \
  libssl-dev \
  vim \
  libxml2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 \
  && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100 \
  && echo "set -o vi" >> /root/.bashrc

# Install Swift compiler
RUN wget https://swift.org/builds/$SWIFT_SNAPSHOT_LOWERCASE/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
    https://swift.org/builds/$SWIFT_SNAPSHOT_LOWERCASE/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz.sig \
  && gpg --keyserver hkp://pool.sks-keyservers.net \
      --recv-keys \
      '7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD' \
      '1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F' \
      'A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6' \
      '5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235' \
      '8513 444E 2DA3 6B7C 1659  AF4D 7638 F1FB 2B2B 08C4' \
  && gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys  \
  && gpg --verify $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz.sig \
  && tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz --strip-components=1 \
  && rm $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && rm $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz.sig \
  && chmod -R go+r /usr/lib/swift \
  && swift --version

# Add utilities
COPY ../../.vim /root/.vim
COPY ../../.vimrc /root/.vimrc

CMD /bin/bash
