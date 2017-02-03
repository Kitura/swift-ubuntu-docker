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

FROM ibmcom/ubuntu:14.04
MAINTAINER IBM Swift Engineering at IBM Cloud
LABEL Description="Linux Ubuntu 14.04 image with the Swift binaries and tools."

USER root

# Set environment variables for image
ENV SWIFT_SNAPSHOT swift-3.0.2-RELEASE
ENV SWIFT_SNAPSHOT_LOWERCASE swift-3.0.2-release
ENV UBUNTU_VERSION ubuntu14.04
ENV UBUNTU_VERSION_NO_DOTS ubuntu1404
ENV HOME /root
ENV WORK_DIR /root
ENV PATH $WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH

# Set WORKDIR
WORKDIR ${WORK_DIR}

ADD .vim /root/.vim
ADD .vimrc /root/.vimrc

# Linux OS utils and libraries and set clang 3.8 as default
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y \
  build-essential \
  clang-3.8 \
  git \
  libpython2.7 \
  libicu-dev \
  wget \
  libcurl4-openssl-dev \
  vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 \
  && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100 \
  && echo "set -o vi" >> /root/.bashrc

# Install Swift compiler
RUN wget https://swift.org/builds/$SWIFT_SNAPSHOT_LOWERCASE/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && rm $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && swiftc -h

CMD /bin/bash
