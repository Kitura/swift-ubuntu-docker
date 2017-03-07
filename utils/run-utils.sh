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

# Runs your Swift app in a Docker container
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/common-utils.sh

#----------------------------------------------------------
function help {
  SCRIPT=`basename "$0"`
  cat <<-!!EOF
    Usage: $SCRIPT <project folder> [ run <program name> ]

    Where:
      run                     Runs your project
!!EOF
}

#----------------------------------------------------------
# MAIN
# ---------------------------------------------------------
# Runtime arguments
ACTION="$1"
PROGRAM_NAME="$2"

# Validate input arguments
[[ ( -z $ACTION ) || ( -z $PROGRAM_NAME ) ]] && help && exit 0

# Invoke corresponding handler
# Invoke corresponding handler
case $ACTION in
"run")                 init && run;;
*)                     help;;
esac
