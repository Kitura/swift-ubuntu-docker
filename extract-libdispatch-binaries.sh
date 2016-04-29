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
    --sourceFolder=*)
    sourceFolder="${i#*=}"
    shift # past argument=value
    ;;
    *)
        # unknown option
    ;;
esac
done

#tmp
container=3495d31626b8
swiftVersion=swift-DEVELOPMENT-SNAPSHOT-2016-04-25-a
linuxVersion=ubuntu15.10
outputFolder=/Users/olivieri/tmp/newtest

# Variables
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
tarFileName=$swiftVersion-libdispatch.tar.gz

echo
echo "Creating $tarFileName file..."
#tarFileName="${sourceFolder##*${sourceFolder}}"
cd $outputFolder && tar -cvzf $tarFileName *
echo "Finished creating '$tarFileName' in $outputFolder."
# Untarring file
# tar -xvf $tarFileName