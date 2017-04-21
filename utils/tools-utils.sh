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
  MIN_SEVER_PORT=$(( DEBUG_PORT + 1 ))
  MAX_SEVER_PORT=$(( MIN_SEVER_PORT + 1 ))
  lldb-server platform --port-offset=$DEBUG_PORT --listen *:$DEBUG_PORT --min-gdbserver-port $MIN_SEVER_PORT --max-gdbserver-port $MAX_SEVER_PORT --server &
  echo "Started debug server on port $DEBUG_PORT (min-gdbserver-port: $MIN_SEVER_PORT, max-gdbserver-port: $MAX_SEVER_PORT)."
}

#----------------------------------------------------------
function buildProject {

  echo "Compiling the project..."
  echo "Build configuration: $BUILD_CONFIGURATION"
  swift build --configuration $BUILD_CONFIGURATION --build-path $BUILD_DIR
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
ACTION="$1"
BUILD_CONFIGURATION="$2"
PROGRAM_NAME="$3"
DEBUG_PORT="$4"

# Validate input arguments
if [[ -z $ACTION ]] ; then
  ACTION="build"
  BUILD_CONFIGURATION="debug"
fi

if [ "$ACTION" = "debug" ] ; then
  BUILD_CONFIGURATION="debug"
  PROGRAM_NAME="$2"
  DEBUG_PORT="$3"
fi

if [ "$ACTION" = "run" ] ; then
  BUILD_CONFIGURATION="debug"
fi

[ "$ACTION" = "build" ] && [[ -z $BUILD_CONFIGURATION ]] && BUILD_CONFIGURATION="debug"
[ "$ACTION" = "run" ] && [[ -z $PROGRAM_NAME ]] && help && exit 0
[ "$ACTION" = "debug" ] && [[ ( -z $PROGRAM_NAME ) || ( -z $DEBUG_PORT ) ]] && help && exit 0

# Invoke corresponding handler
case $ACTION in
"run")                 init && run;;
"build")               init && buildProject;;
"debug")               init && debugServer && run;;
"test")                init && runTests;;
*)                     help;;
esac
