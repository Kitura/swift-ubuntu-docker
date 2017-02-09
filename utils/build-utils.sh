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

function help {
  SCRIPT=`basename "$0"`
  cat <<-!!EOF
    Usage: $SCRIPT <project folder> [ build | run <program name> | debug <program name> <debug port> | test ]

    Where:
      build                   Compiles your project
      run                     Runs your project
      debug                   Starts debug server and your program
      test                    Runs test cases
      install-system-libs     Installs any system libraries from dependencies
!!EOF
}

#----------------------------------------------------------
function init {
  # Enter the project directory
  cd $PROJECT_FOLDER
  echo "Current folder is: `pwd`"
}

#----------------------------------------------------------
function debugServer {
  lldb-server platform --listen *:$DEBUG_PORT &
  echo "Started debug server on port $DEBUG_PORT."
}

#----------------------------------------------------------
function installSystemLibraries {

  # Fetch all of the dependencies
  echo "Fetching Swift packages"
  swift package fetch

  echo "Installing system dependencies (if any)..."

  # Update the Package cache
  sudo apt-get update &> /dev/null

  # Install all the APT dependencies
  egrep -R "Apt *\(" Packages/*/Package.swift \
    | sed -e 's/^.*\.Apt *( *" *//' -e 's/".*$//' \
    | xargs -n 1 sudo apt-get install -y &> /dev/null
}

#----------------------------------------------------------
function buildProject {

  echo "Compiling the project..."
  swift build
}

#----------------------------------------------------------
function runTests {
  echo "Running tests..."
  swift test
}

#----------------------------------------------------------
function run {
  echo "Running program..."
  .build/debug/$PROGRAM_NAME
}

#----------------------------------------------------------
# MAIN
# ---------------------------------------------------------
# Runtime arguments
PROJECT_FOLDER="$1"
ACTION="$2"
PROGRAM_NAME="$3"
DEBUG_PORT="$4"

# Validate input arguments
[[ -z $PROJECT_FOLDER ]] && help && exit 0
if [[ -z $ACTION ]] ; then
  ACTION="build"
fi
[ "$ACTION" = "run" ] && [[ -z $PROGRAM_NAME ]] && help && exit 0
[ "$ACTION" = "debug" ] && [[ ( -z $PROGRAM_NAME ) || ( -z $DEBUG_PORT ) ]] && help && exit 0

# Invoke corresponding handler
case $ACTION in
"run")                 init && installSystemLibraries && buildProject && run;;
"build")               init && installSystemLibraries && buildProject;;
"debug")               init && debugServer && installSystemLibraries && buildProject && run;;
"test")                init && runTests;;
"install-system-libs") init && installSystemLibraries;;
*)                     help;;
esac
