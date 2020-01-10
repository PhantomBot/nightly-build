#!/bin/bash
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
git checkout --progress master
LAST_REPO_VERSION=$(cat last_repo_version)

cd ${HOME}

git clone --progress --depth=1 https://github.com/PhantomBot/PhantomBot.git
cd PhantomBot
PB_VERSION=$(grep "property name=\"version\"" build.xml | perl -e 'while(<STDIN>) { ($ver) = $_ =~ m/\s+<property name=\"version\" value=\"(.*)\" \/>/; } print $ver;')
ant -noinput -buildfile build.xml distclean clean
ant -noinput -buildfile build.xml -Dbuildtype=nightly_build -Dversion=${PB_VERSION}-NB-$(date +%Y%m%d) dist
if [[ $? -ne 0 ]]; then
    exit 1
fi
REPO_VERSION=$(git rev-parse --short HEAD)
cp -f ${MASTER}/dist/PhantomBot*zip ${BUILDS}/${BUILD}
cp -f ${MASTER}/dist/PhantomBot*zip ${HISTORICAL}/${BUILD_DATED}

PBFOLDER=PhantomBot-${PB_VERSION}-NB-$(date +%Y%m%d)

cd ${MASTER}/dist/

echo "Lin zip"
zip -r ${BUILDS}/${LIN_BUILD} ${PBFOLDER} -x '*java-runtime/*' -x '*java-runtime-macos/*' -x '*launch.bat'
echo "Win zip"
zip -r ${BUILDS}/${WIN_BUILD} ${PBFOLDER} -x '*java-runtime-linux/*' -x '*java-runtime-macos/*' -x '*launch.sh' -x '*launch-service.sh'
echo "Mac zip"
zip -r ${BUILDS}/${MAC_BUILD} ${PBFOLDER} -x '*java-runtime-linux/*' -x '*java-runtime/*' -x '*launch.bat'
echo "Arm zip"
zip -r ${BUILDS}/${ARM_BUILD} ${PBFOLDER} -x '*java-runtime-linux/*' -x '*java-runtime/*' -x '*java-runtime-macos/*' -x '*launch.bat'

cd ${BUILDS}
if [[ "${LAST_REPO_VERSION}" = "${REPO_VERSION}" ]]; then
    export BUILD_STR="${COMMITSTR} (Repo: ${REPO_VERSION}) (No Changes)"
else
    export BUILD_STR="${COMMITSTR} (Repo: ${REPO_VERSION}) ([View Changes](https://github.com/PhantomBot/PhantomBot/compare/${LAST_REPO_VERSION}...${REPO_VERSION}))"
fi
cat builds.md | perl -e 'while(<STDIN>) { if ($_ =~ /------/ ) { print $_; print "###### $ENV{BUILD_STR}\n"; } else { print $_; } }' > builds.new
head -25 builds.new > builds.md
rm -f builds.new
echo ${REPO_VERSION} > last_repo_version
git config user.email "PhantomBot-Nightly-build@github-actions.local"
git config user.name "GitHub-Actions/PhantomBot/nightly-build"
git add ${BUILD} ${LIN_BUILD} ${WIN_BUILD} ${MAC_BUILD} ${ARM_BUILD} historical/${BUILD_DATED} builds.md last_repo_version
cd ${BUILDS}/historical
find . -mtime +20 -exec git rm {} \;
git commit -m "${BUILD_STR}"
if [[ "${DRY_RUN}" = "false" ]]; then
    git push "https://${GITHUB_ACTOR}:${TOKEN_GITHUB}@github.com/${GITHUB_REPOSITORY}.git"
else
    cd ${BUILDS}
    echo "$(ls)"
    echo ""
    echo "$(unzip -l ${ARM_BUILD})"
fi
