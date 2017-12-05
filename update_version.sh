#!/bin/sh

set -o nounset

updateVersion() {
  VERSION_TO_CONSTANT="$1"
  FILE_WITH_CONSTANTS_PATH="$2"

  echo "Updating version to '$VERSION_TO_CONSTANT' in '${FILE_WITH_CONSTANTS_PATH}'..."
  perl -0777 -i -pe "s/(<property name=\"IMPL_VERSION\" value=\")(.*?)(\" \/>)(.*)/\${1}${VERSION_TO_CONSTANT}\${3}\${4}/s" "$FILE_WITH_CONSTANTS_PATH"
}


VERSION_TO=$1

updateVersion "$VERSION_TO" build.xml
