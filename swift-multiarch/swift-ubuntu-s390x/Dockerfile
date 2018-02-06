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

FROM s390x/ubuntu
MAINTAINER IBM Swift Engineering at IBM Cloud

USER root

# Set environment variables for image
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
  libxml2-dev \
  vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 \
  && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100 \
  && echo "set -o vi" >> /root/.bashrc

# Install Swift compiler
COPY swift-4.0.3-s390x-ub1604-20180205-R.tgz swift-4.0.3-s390x-ub1604-20180205-R.tgz
COPY binutils-2.27.tar.gz binutils-2.27.tar.gz

RUN tar -xzvf swift-4.0.3-s390x-ub1604-20180205-R.tgz \
    && tar -xvzf binutils-2.27.tar.gz \
    && rm swift-4.0.3-s390x-ub1604-20180205-R.tgz \
    && rm binutils-2.27.tar.gz \
    && swift --version

# Add gold linker to PATH
ENV PATH "/opt/binutils-2.27/bin:$PATH"

# Add utilities
#COPY .vim /root/.vim
#COPY .vimrc /root/.vimrc

CMD /bin/bash
