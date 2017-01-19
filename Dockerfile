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

# Dockerfile to build a Docker image with the Swift binaries and its dependencies.

FROM ubuntu:14.04
MAINTAINER IBM Swift Engineering at IBM Cloud
LABEL Description="Linux Ubuntu 14.04 image with the Swift binaries."

# Set environment variables for image
ENV SWIFT_SNAPSHOT swift-3.0.2-RELEASE
ENV SWIFT_SNAPSHOT_LOWERCASE swift-3.0.2-release
ENV UBUNTU_VERSION ubuntu14.04
ENV UBUNTU_VERSION_NO_DOTS ubuntu1404
ENV HOME /root
ENV WORK_DIR /root

# Set WORKDIR
WORKDIR ${WORK_DIR}

# Linux OS utils and libraries
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y \
  build-essential \
  clang-3.8 \
  git \
  libpython2.7 \
  libicu-dev \
  wget \
  libcurl4-openssl-dev \
  vim \
  && apt-get clean

# Set clang 3.8 as default
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100

ADD .vim /root/.vim
ADD .vimrc /root/.vimrc

RUN echo "set -o vi" >> /root/.bashrc

# Install Swift compiler
RUN wget https://swift.org/builds/$SWIFT_SNAPSHOT_LOWERCASE/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && rm $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
ENV PATH $WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH
RUN swiftc -h

# Security & hardening
# For details on resolving reported vulnerabilities, see:
# https://console.ng.bluemix.net/docs/containers/container_security_image.html#container_security_image
RUN sed -i 's/^.*PASS_MAX_DAYS.*$/PASS_MAX_DAYS\t90/' /etc/login.defs && \
  sed -i 's/^.*PASS_MIN_DAYS.*$/PASS_MIN_DAYS\t1/' /etc/login.defs && \
  sed -i 's/^.*PASS_MIN_LEN.*$/PASS_MIN_LEN\t>=\ 8/' /etc/login.defs && \
  sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

# See following URL for details: http://tldp.org/LDP/lfs/LFS-BOOK-6.1.1-HTML/chapter06/pwdgroup.html
RUN touch /var/run/utmp /var/log/{btmp,lastlog,wtmp}
RUN chgrp -v utmp /var/run/utmp /var/log/lastlog
RUN chmod -v 664 /var/run/utmp /var/log/lastlog

# See following URL for details: http://www.deer-run.com/~hal/sysadmin/pam_cracklib.html
RUN touch /etc/security/opasswd
RUN chown root:root /etc/security/opasswd
RUN chmod 600 /etc/security/opasswd

# See following URL for details: http://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/
RUN grep -q '^net.ipv4.tcp_syncookies' /etc/sysctl.conf && sed -i 's/^net.ipv4.tcp_syncookies.*/net.ipv4.tcp_syncookies = 1/' /etc/sysctl.conf || echo 'net.ipv4.tcp_syncookies = 1' >> /etc/sysctl.conf
RUN grep -q '^net.ipv4.ip_forward' /etc/sysctl.conf && sed -i 's/^net.ipv4.ip_forward.*/net.ipv4.ip_forward = 0/' /etc/sysctl.conf || echo 'net.ipv4.ip_forward = 0' >> /etc/sysctl.conf
RUN grep -q '^net.ipv4.icmp_echo_ignore_broadcasts' /etc/sysctl.conf && sed -i 's/^net.ipv4.icmp_echo_ignore_broadcasts.*/net.ipv4.icmp_echo_ignore_broadcasts = 1/' /etc/sysctl.conf || echo 'net.ipv4.icmp_echo_ignore_broadcasts = 1' >> /etc/sysctl.conf
