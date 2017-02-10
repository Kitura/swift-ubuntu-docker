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

#----------------------------------------------------------
function run {
  echo "Running program..."
  .build/debug/$PROGRAM_NAME
}

#----------------------------------------------------------
function init {
  # Enter the project directory
  cd $PROJECT_FOLDER
  echo "Current folder is: `pwd`"
  installSystemLibraries
}

#----------------------------------------------------------
function installSystemLibraries {

  # Fetch all of the dependencies
  if type "swift" > /dev/null; then
    echo "Fetching Swift packages"
    swift package fetch
  fi

  echo "Installing system dependencies (if any)..."

  # Update the Package cache
  sudo apt-get update &> /dev/null

  # Install all the APT dependencies
  egrep -R "Apt *\(" Packages/*/Package.swift \
    | sed -e 's/^.*\.Apt *( *" *//' -e 's/".*$//' \
    | xargs -n 1 sudo apt-get install -y &> /dev/null
}
