#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No colour
GREEN='\033[0;32m'

echo "Creating and releasing .kpz file"

FILENAME=$(node checkVersionNumber.js filename)
FILE=./${FILENAME}

if test -f "$FILE"; then
    echo "Plugin .kpz file already exists, previous version deleted"
    rm -r $FILE
fi
echo "Creating new .kpz file"
zip -r $FILE Koha/

NEW_VERSION=$(node checkVersionNumber.js version)

if [ "$NEW_VERSION" = 'No plugin file found' ]; then
    echo -e "${RED}No plugin file could be identified, have you created one?"
    echo -e "A plugin file must contain 'use base qw(Koha::Plugins::Base);'${NC}"
    exit
elif [ "$NEW_VERSION" = 'No version found' ]; then
    echo -e "${RED}No version could be identified, does your plugin file include one?"
    echo -e "A plugin file must contain 'our \$VERSION = "version here";'${NC}"
    exit
else
    NEW_VERSION_NUMBER=${NEW_VERSION:1}
fi

PREVIOUS_VERSION=$(git log -1 --pretty=oneline | grep -E -o 'v.{0,4}')
PREVIOUS_VERSION_NUMBER=${PREVIOUS_VERSION:1}

if [ "$NEW_VERSION_NUMBER" != "$PREVIOUS_VERSION_NUMBER" ]; then
    echo "Version has been updated - starting upload"
    git add .
    git commit -m "$NEW_VERSION"
    git tag "v$NEW_VERSION_NUMBER"
    git push --force-with-lease
    echo -e "${GREEN}Plugin has been pushed to Github and a release is being generated${NC}"
else
    echo -e "${RED}WARNING: The Plugin version needs to be updated - please check the .pm file and update the version${NC}"
fi