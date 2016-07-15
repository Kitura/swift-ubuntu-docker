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

# Utility script used for extracting libdispatch binaries from the Docker container.

for i in "$@"
do
case $i in
    --container=*)
    container="${i#*=}"
    shift # past argument=value
    ;;
    --swiftVersion=*)
    swiftVersion="${i#*=}"
    shift # past argument=value
    ;;
    --linuxVersion=*)
    linuxVersion="${i#*=}"
    shift # past argument=value
    ;;
    --outputFolder=*)
    outputFolder="${i#*=}"
    shift # past argument=value
    ;;
    *)
        # unknown option
    ;;
esac
done

# Variables
#container=fb5e2fd45218
#swiftVersion=swift-DEVELOPMENT-SNAPSHOT-2016-06-06-a
#linuxVersion=ubuntu14.04
#outputFolder=/Users/olivieri/tmp/libdispatch
sourceFolder=$swiftVersion-$linuxVersion

echo
echo "Starting execution for extracting libdispatch binaries..."
echo "Docker container: $container"
echo "Swift version: $swiftVersion"
echo "Linux version: $linuxVersion"
echo "Source folder on docker container: $sourceFolder"
echo "Output folder: $outputFolder"
echo
echo "Deleting '$outputFolder'..."
rm -rf $outputFolder
echo "Creating folder '$outputFolder'..."
mkdir -p $outputFolder

(IFS='
'
for line in `docker diff $container`; do
  line=${line#"C "}
  line=${line#"A "}
  path=$line
  basename="$(basename $line)"
  dir="$(dirname $line)"
  if [[ "$dir" == *"$sourceFolder"* ]]; then
    target="${path##*${sourceFolder}}"
    if [[ "$basename" == *"."* ]]; then
      #File
      echo "Copying file: $target"
      docker cp $container:$path $outputFolder$target
    else
      #Folder
      echo "Creating folder: $target"
      mkdir -p $outputFolder$target
    fi
  fi
done)

echo "Finished extracting libdispatch binaries."
echo

tarFileName=$swiftVersion-libdispatch.tar.gz
echo "Creating $tarFileName file..."
cd $outputFolder && tar -cvzf $tarFileName *
echo "Finished creating '$tarFileName' in $outputFolder."
# Untarring file
# tar -xvf $tarFileName
