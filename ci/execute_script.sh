#!/bin/bash
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

set -ev

prefix="ENV SWIFT_SNAPSHOT swift-"
suffix="-RELEASE"

DEVELOPMENT_SNAPSHOT=$(grep "$prefix" swift-development/Dockerfile)
DEVELOPMENT_SNAPSHOT=${DEVELOPMENT_SNAPSHOT//"$prefix"}
DEVELOPMENT_VERSION=${DEVELOPMENT_SNAPSHOT//"$suffix"}

RUNTIME_SNAPSHOT=$(grep "$prefix" swift-runtime/Dockerfile)
RUNTIME_SNAPSHOT=${RUNTIME_SNAPSHOT//"$prefix"}
RUNTIME_VERSION=${RUNTIME_SNAPSHOT//"$suffix"}

docker build --pull -t ibmcom/ubuntu:14.04 ./ubuntu-14.04
#docker build --pull -t ibmcom/ubuntu:16.04 ./ubuntu-16.04
docker build -t ibmcom/swift-ubuntu:latest ./swift-development
docker build -t ibmcom/swift-ubuntu-runtime:latest ./swift-runtime
docker tag ibmcom/swift-ubuntu:latest ibmcom/swift-ubuntu:$DEVELOPMENT_VERSION
docker tag ibmcom/swift-ubuntu-runtime:latest ibmcom/swift-ubuntu-runtime:$RUNTIME_VERSION

if [ "$TRAVIS_BRANCH" == "master" ]; then
  docker login -u="$DOCKERHUB_USERNAME" -p="$DOCKERHUB_PASSWORD";
  docker push ibmcom/ubuntu:14.04;
  #docker push ibmcom/ubuntu:16.04;
  docker push ibmcom/swift-ubuntu:latest;
  docker push ibmcom/swift-ubuntu-runtime:latest;
  docker push ibmcom/swift-ubuntu:$DEVELOPMENT_VERSION;
  docker push ibmcom/swift-ubuntu-runtime:$RUNTIME_VERSION;
fi
