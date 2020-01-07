#!/usr/bin/bash
#
# Copyright (C) 2016-2020 phantombot.tv
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# nightlyPBBuild.sh
#
# Performs the Nightly Build of PhantomBot.

MASTER="${HOME}/PhantomBot"
BUILDS="${GITHUB_WORKSPACE}"
HISTORICAL="${BUILDS}/historical/"
DATE=$(date +%m%d%Y)
FULLSTAMP=$(date +%m%d%Y.%H%M%S)
COMMITSTR="Nightly Build at $(date '+%b %d %H:%M:%S %Y (%Z%z)')"
BUILD="PhantomBot-nightly.zip"
LIN_BUILD="PhantomBot-nightly-lin.zip"
WIN_BUILD="PhantomBot-nightly-win.zip"
MAC_BUILD="PhantomBot-nightly-mac.zip"
ARM_BUILD="PhantomBot-nightly-arm.zip"
BUILD_DATED="PhantomBot-nightly-${FULLSTAMP}.zip"
LANG="en_US.UTF-8"

cd ${BUILDS}
LAST_REPO_VERSION=$(cat last_repo_version)

cd ${HOME}

git clone https://github.com/PhantomBot/PhantomBot.git 2>/dev/null 1>&2
cd PhantomBot
PB_VERSION=$(grep "property name=\"version\"" build.xml | perl -e 'while(<STDIN>) { ($ver) = $_ =~ m/\s+<property name=\"version\" value=\"(.*)\" \/>/; } print $ver;')
ant distclean clean 2>/dev/null 1>&2
ant -Dnightly=nightly_build -Dversion=${PB_VERSION}-NB-$(date +%Y%m%d) 2>/dev/null 1>&2
if [[ $? -ne 0 ]]; then
    exit 1
fi
REPO_VERSION=$(git rev-parse --short HEAD)
cp -f ${MASTER}/PhantomBot/dist/PhantomBot*zip ${BUILDS}/${BUILD}
cp -f ${MASTER}/PhantomBot/dist/PhantomBot*zip ${HISTORICAL}/${BUILD_DATED}

PBFOLDER=PhantomBot-${PB_VERSION}-NB-$(date +%Y%m%d)

cd ${MASTER}/PhantomBot/dist/
zip -r ${BUILDS}/${LIN_BUILD} ${PBFOLDER} -x 'java-runtime/*' -x 'java-runtime-macos/*' -x 'launch.bat'
zip -r ${BUILDS}/${WIN_BUILD} ${PBFOLDER} -x 'java-runtime-linux/*' -x 'java-runtime-macos/*' -x 'launch.sh' -x 'launch-service.sh'
zip -r ${BUILDS}/${MAC_BUILD} ${PBFOLDER} -x 'java-runtime-linux/*' -x 'java-runtime/*' -x 'launch.bat'
zip -r ${BUILDS}/${ARM_BUILD} ${PBFOLDER} -x 'java-runtime-linux/*' -x 'java-runtime/*' -x 'java-runtime-macos/*' -x 'launch.bat'

cd ${BUILDS}
git pull 2>/dev/null 1>&2
if [[ "${LAST_REPO_VERSION}" = "${REPO_VERSION}" ]]; then
    export BUILD_STR="${COMMITSTR} (Repo: ${REPO_VERSION}) (No Changes)"
else
    export BUILD_STR="${COMMITSTR} (Repo: ${REPO_VERSION}) ([View Changes](https://github.com/PhantomBot/PhantomBot/compare/${LAST_REPO_VERSION}...${REPO_VERSION}))"
fi
cat builds.md | perl -e 'while(<STDIN>) { if ($_ =~ /------/ ) { print $_; print "###### $ENV{BUILD_STR}\n"; } else { print $_; } }' > builds.new
head -25 builds.new > builds.md
rm -f builds.new
echo ${REPO_VERSION} > last_repo_version
git add ${BUILD} ${LIN_BUILD} ${WIN_BUILD} ${MAC_BUILD} ${ARM_BUILD} historical/${BUILD_DATED} builds.md last_repo_version 2>/dev/null 1>&2
cd ${BUILDS}/historical
find . -mtime +20 -exec git rm {} \; 2>/dev/null 1>&2
git commit -m "${BUILD_STR}" 2>/dev/null 1>&2
if [[ "${INPUT_DRY_RUN}" = "false" ]]; then
    git push "https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" 2>/dev/null 1>&2
else
    echo "$(ls)"
    echo.
    echo "$(unzip -l ${ARM_BUILD})"
fi
