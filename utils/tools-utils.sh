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

# Compiles, debugs, or runs your Swift app in a Docker container
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/common-utils.sh

#----------------------------------------------------------
function help {
  SCRIPT=`basename "$0"`
  cat <<-!!EOF
    Usage: $SCRIPT <project folder> [ build <configuration mode> | run <configuration mode> <program name> | debug <program name> <debug port> | test ]

    Where:
      build                   Compiles your project
      run                     Runs your project
      debug                   Starts debug server and your program
      test                    Runs test cases
!!EOF
}

#----------------------------------------------------------
function debugServer {
  lldb-server platform --listen *:$DEBUG_PORT --server &
  echo "Started debug server on port $DEBUG_PORT."
}

#----------------------------------------------------------
function buildProject {

  echo "Compiling the project..."
  echo "Build configuration: $BUILD_CONFIGURATION"
  swift build --configuration $BUILD_CONFIGURATION
}

#----------------------------------------------------------
function runTests {
  echo "Running tests..."
  swift test
}

#----------------------------------------------------------
# MAIN
# ---------------------------------------------------------
# Runtime arguments
PROJECT_FOLDER="$1"
ACTION="$2"
BUILD_CONFIGURATION="$3"
PROGRAM_NAME="$4"
DEBUG_PORT="$5"

# Validate input arguments
[[ -z $PROJECT_FOLDER ]] && help && exit 0

if [[ -z $ACTION ]] ; then
  ACTION="build"
  BUILD_CONFIGURATION="debug"
fi

if [ "$ACTION" = "debug" ] ; then
  BUILD_CONFIGURATION="debug"
  PROGRAM_NAME="$3"
  DEBUG_PORT="$4"
fi

[ "$ACTION" = "build" ] && [[ -z $BUILD_CONFIGURATION ]] && BUILD_CONFIGURATION="debug"
[ "$ACTION" = "run" ] && [[ -z $PROGRAM_NAME ]] && help && exit 0
[ "$ACTION" = "debug" ] && [[ ( -z $PROGRAM_NAME ) || ( -z $DEBUG_PORT ) ]] && help && exit 0

# Invoke corresponding handler
case $ACTION in
"run")                 init && buildProject && run;;
"build")               init && buildProject;;
"debug")               init && buildProject && run && debugServer;;
"test")                init && runTests;;
*)                     help;;
esac
