#!/usr/bin/bash
#
# Copyright (C) 2016-2017 phantombot.tv
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
# Performs the Nightly Build of PhantomBot on IllusionaryOne's server.
#
# Configuration Notes:
# The nightly-build area must be created using ssh pull rather than https so that
# it can authenticate strictly via SSH key and not ask for username and password.
#
# This expects Oracle Java and OpenJDK to be installed.
#

MASTER="/home/builder/nightly/"
BUILDS="/home/builder/nightly-build/"
HISTORICAL="${BUILDS}/historical/"
DATE=$(date +%m%d%Y)
FULLSTAMP=$(date +%m%d%Y.%H%M%S)
COMMITSTR="Nightly Build at $(date '+%b %d %H:%M:%S %Y (%Z%z)')"
BUILD="PhantomBot-nightly.zip"
BUILD_DATED="PhantomBot-nightly-${FULLSTAMP}.zip"
OPENJDK_BUILD="PhantomBot-nightly-openjdk.zip"
OPENJDK_BUILD_DATED="PhantomBot-nightly-openjdk-${FULLSTAMP}.zip"
LANG="en_US.UTF-8"
LAST_REPO_VERSION=$(cat ~/.last_repo_version)

# Use Oracle Java
export JAVA_HOME="/usr/java/latest"
export PATH=${JAVA_HOME}/bin:${PATH}

cd /home/builder
rm -Rf nightly
mkdir nightly
cd nightly
/usr/local/bin/hub clone https://github.com/PhantomBot/PhantomBot.git 2>/dev/null 1>&2
cd PhantomBot
PB_VERSION=$(grep "property name=\"version\"" build.xml | perl -e 'while(<STDIN>) { ($ver) = $_ =~ m/\s+<property name=\"version\" value=\"(.*)\" \/>/; } print $ver;')
/usr/bin/ant clean 2>/dev/null 1>&2
/usr/bin/ant -Dnightly=nightly_build -Dversion=${PB_VERSION}-NB-$(date +%Y%m%d) 2>/dev/null 1>&2
if [[ $? -ne 0 ]]; then
    exit 1
fi
REPO_VERSION=$(git rev-parse --short HEAD)
cp -f ${MASTER}/PhantomBot/dist/PhantomBot*zip ${BUILDS}/${BUILD}
cp -f ${MASTER}/PhantomBot/dist/PhantomBot*zip ${HISTORICAL}/${BUILD_DATED}

# Use OpenJDK
export JAVA_HOME="/etc/alternatives/java_sdk_1.8.0_openjdk"
export PATH=${JAVA_HOME}/bin:${PATH}
/usr/bin/ant clean 2>/dev/null 1>&2
/usr/bin/ant -Dnightly=nightly_build -Dversion=${PB_VERSION}-NB-$(date +%Y%m%d) 2>/dev/null 1>&2
if [[ $? -ne 0 ]]; then
    exit 1
fi
cp -f ${MASTER}/PhantomBot/dist/PhantomBot*zip ${BUILDS}/${OPENJDK_BUILD}
cp -f ${MASTER}/PhantomBot/dist/PhantomBot*zip ${HISTORICAL}/${OPENJDK_BUILD_DATED}

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
git add ${BUILD} ${OPENJDK_BUILD} historical/${BUILD_DATED} historical/${OPENJDK_BUILD_DATED} builds.md 2>/dev/null 1>&2
cd ${BUILDS}/historical
find . -mtime +20 -exec git rm {} \; 2>/dev/null 1>&2
git commit -m "${BUILD_STR}" 2>/dev/null 1>&2
git push 2>/dev/null 1>&2

echo ${REPO_VERSION} > ~/.last_repo_version
