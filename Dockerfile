FROM ubuntu:15.10
MAINTAINER Mobile Innovation Lab (IBM)
LABEL Description="Image to create a Linux environment with the latest Swift compiler."

# Variables
ENV SWIFT_SNAPSHOT swift-DEVELOPMENT-SNAPSHOT-2016-02-03-a
ENV UBUNTU_VERSION ubuntu15.10
ENV UBUNTU_VERSION_NO_DOTS ubuntu1510
ENV HOME /root
ENV WORK_DIR /root

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

# Set WORKDIR
WORKDIR ${WORK_DIR}

# Install Swift compiler
RUN wget https://swift.org/builds/development/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
RUN tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
ENV PATH $WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH
RUN swiftc -h

# Clone and install libdispatch
#RUN git clone https://github.com/apple/swift-corelibs-libdispatch.git
RUN git clone -b opaque-pointer git://github.com/seabaylea/swift-corelibs-libdispatch
RUN cd swift-corelibs-libdispatch && sh ./autogen.sh && ./configure && make && make install

# Add module map file for libdispatch
#RUN git clone git@github.ibm.com:ibmswift/IncludeChanges.git
#RUN cp $WORK_DIR/IncludeChanges/include-dispatch/module.modulemap /usr/local/include/dispatch/module.modulemap
#RUN rm -rf IncludeChanges
