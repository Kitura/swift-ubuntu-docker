##
# Copyright IBM Corporation 2017
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

FROM ibmcom/ubuntu:14.04
MAINTAINER IBM Swift Engineering at IBM Cloud
LABEL Description="Linux Ubuntu 14.04 image for execution of Swift applications."

USER root

# Set environment variables for image
ARG VERSION=${VERSION}
ENV SWIFT_SNAPSHOT swift-${VERSION}-RELEASE
ENV SWIFT_SNAPSHOT_LOWERCASE swift-${VERSION}-release
ENV UBUNTU_VERSION ubuntu14.04
ENV UBUNTU_VERSION_NO_DOTS ubuntu1404
ENV WORK_DIR /

# Set WORKDIR
WORKDIR ${WORK_DIR}

# Linux OS utils & Swift libraries
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y \
  libicu-dev \
  libcurl4-openssl-dev \
  wget \
  && apt-get clean \
  && wget -q https://swift.org/builds/$SWIFT_SNAPSHOT_LOWERCASE/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
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
  && tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz $SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/lib/swift/linux --strip-components=1 \
  && rm $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && rm $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz.sig \
  && find /usr/lib/swift/linux -type f ! -name '*.so' -delete \
  && rm -rf /usr/lib/swift/linux/*/ \
  && chmod -R go+r /usr/lib/swift \
  && apt-get remove -y gcc cpp sgml-base icu-devtools gcc-4.8 cpp-4.8 libc6-dev binutils manpages-dev manpages wget pkg-config perl \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD /bin/bash
