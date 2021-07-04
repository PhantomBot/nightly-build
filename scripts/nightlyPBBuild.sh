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
# BUILD="PhantomBot-nightly.zip"
LIN_BUILD="PhantomBot-nightly-lin.zip"
WIN_BUILD="PhantomBot-nightly-win.zip"
MAC_BUILD="PhantomBot-nightly-mac.zip"
ARMBSDOTHER_BUILD="PhantomBot-nightly-arm-bsd-other.zip"
BUILD_DATED="PhantomBot-nightly-${FULLSTAMP}.zip"
LANG="en_US.UTF-8"

cd ${BUILDS}
git checkout --progress master
LAST_REPO_VERSION=$(cat last_repo_version)

cd ${HOME}

git clone --progress --depth=1 https://github.com/PhantomBot/PhantomBot.git
cd PhantomBot
REPO_VERSION=$(git rev-parse --short HEAD)

if [[ "${LAST_REPO_VERSION}" = "${REPO_VERSION}" ]]; then
    ISOLD=find ${BUILDS}/historical -type f -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 | awk '{s=gensub(/.+-([0-9]{2})([0-9]{2})([0-9]{4})\.([0-9]{2})([0-9]{2})([0-9]{2})\.zip/, "\\3 \\1 \\2 \\4 \\5 \\6", ""); t=mktime(s); d=systime() - t; if (d >= 1728000){ print("true"); } else { print("false"); }}' 2>/dev/null

    if [[ "${ISOLD}" = "true" ]]; then
        echo "Nightly build is old, building anyway..."
    else
        echo "No changes, aborting..."
        exit 0
    fi
fi

PB_VERSION=$(grep "property name=\"version\"" build.xml | perl -e 'while(<STDIN>) { ($ver) = $_ =~ m/\s+<property name=\"version\" value=\"(.*)\" \/>/; } print $ver;')
ant -noinput -buildfile build.xml distclean
sed -i -r "s/revision=\"[A-Za-z0-9._-]+\"/revision=\"${REPO_VERSION}\"/;s/branch=\"[A-Za-z0-9._-]+\"/branch=\"${PB_VERSION}-NB-${DATE}\"/" ivy.xml
ant -noinput -buildfile build.xml -Dbuildtype=nightly_build -Drollbar_token=${ROLLBAR_TOKEN} -Drollbar_endpoint=${ROLLBAR_ENDPOINT} -Dversion=${PB_VERSION}-NB-${DATE} jar
if [[ $? -ne 0 ]]; then
    exit 1
fi

PBFOLDER=PhantomBot-${PB_VERSION}-NB-${DATE}

cd ${MASTER}/dist/
# echo "Full zip"
# zip -9 -r ${MASTER}/dist/${BUILD} ${PBFOLDER}
echo "Lin zip"
zip -9 -r ${MASTER}/dist/${LIN_BUILD} ${PBFOLDER} -x '*java-runtime/*' -x '*java-runtime-macos/*' -x '*launch.bat' -x '*launch-bsd.sh' -x '*launch-bsd-service.sh'
echo "Win zip"
zip -9 -r ${MASTER}/dist/${WIN_BUILD} ${PBFOLDER} -x '*java-runtime-linux/*' -x '*java-runtime-macos/*' -x '*launch.sh' -x '*launch-service.sh' -x '*launch-bsd.sh' -x '*launch-bsd-service.sh'
echo "Mac zip"
zip -9 -r ${MASTER}/dist/${MAC_BUILD} ${PBFOLDER} -x '*java-runtime-linux/*' -x '*java-runtime/*' -x '*launch.bat' -x '*launch-bsd.sh' -x '*launch-bsd-service.sh'
echo "Arm zip"
zip -9 -r ${MASTER}/dist/${ARMBSDOTHER_BUILD} ${PBFOLDER} -x '*java-runtime-linux/*' -x '*java-runtime/*' -x '*java-runtime-macos/*' -x '*launch.bat'

echo "Move zips"
# cp -f ${MASTER}/dist/${BUILD} ${HISTORICAL}/${BUILD_DATED}
cp -f ${MASTER}/dist/${ARMBSDOTHER_BUILD} ${HISTORICAL}/${BUILD_DATED}
# mv -f ${MASTER}/dist/${BUILD} ${BUILDS}/${BUILD}
mv -f ${MASTER}/dist/${LIN_BUILD} ${BUILDS}/${LIN_BUILD}
mv -f ${MASTER}/dist/${WIN_BUILD} ${BUILDS}/${WIN_BUILD}
mv -f ${MASTER}/dist/${MAC_BUILD} ${BUILDS}/${MAC_BUILD}
mv -f ${MASTER}/dist/${ARMBSDOTHER_BUILD} ${BUILDS}/${ARMBSDOTHER_BUILD}

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
git add ${LIN_BUILD} ${WIN_BUILD} ${MAC_BUILD} ${ARMBSDOTHER_BUILD} historical/${BUILD_DATED} builds.md last_repo_version
cd ${BUILDS}/historical
find . | awk '{s=gensub(/.+-([0-9]{2})([0-9]{2})([0-9]{4})\.([0-9]{2})([0-9]{2})([0-9]{2})\.zip/, "\\3 \\1 \\2 \\4 \\5 \\6", ""); t=mktime(s); d=systime() - t; if (d >= 1728000){ printf("timestamp: %d diff: %d\n%s\n",t, d, s); system("git rm "$1)}}' 2>/dev/null
git commit -m "${BUILD_STR}"
if [[ "${DRY_RUN}" = "false" ]]; then
    git push "https://${GITHUB_ACTOR}:${TOKEN_GITHUB}@github.com/${GITHUB_REPOSITORY}.git"
else
    cd ${BUILDS}
    echo "$(ls -lah)"
fi
