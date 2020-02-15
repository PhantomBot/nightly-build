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
# nightlyPBDocker.sh
#
# Performs the Nightly Docker Build of PhantomBot.

MASTER="${HOME}/PhantomBot"
DOCKER_BUILD="/opt/PhantomBot"
DATE=$(date +%m%d%Y)

cd ${HOME}

git clone --progress --depth=1 https://github.com/PhantomBot/PhantomBot.git
cd PhantomBot
PB_VERSION=$(grep "property name=\"version\"" build.xml | perl -e 'while(<STDIN>) { ($ver) = $_ =~ m/\s+<property name=\"version\" value=\"(.*)\" \/>/; } print $ver;')
ant -noinput -buildfile build.xml distclean

REPO_VERSION=$(git rev-parse --short HEAD)
PBFOLDER=PhantomBot-${PB_VERSION}-NB-${DATE}

HTTPCODE=$(curl -s -I 'https://registry.hub.docker.com/v2/repositories/${DOCKER_REPO}/tags/${REPO_VERSION}/' | head -n 1 | cut  -d$' ' -f2)

if [[ "${HTTPCODE}" = "200" ]]; then
    exit 0
fi

mkdir -p ${DOCKER_BUILD}
cp -rf ${MASTER}/* ${DOCKER_BUILD}
cd ${DOCKER_BUILD}

sed -i "s/ant jar/ant -noinput -buildfile build.xml -Dbuildtype=nightly_build -Dversion=${PB_VERSION}-NB-${DATE} jar/" Dockerfile
sed -i "s/\/dist\/build\//\/dist\/${PBFOLDER}\//" Dockerfile

docker build . --file Dockerfile --tag ${DOCKER_REPO}:${REPO_VERSION}
docker push ${DOCKER_REPO}:${REPO_VERSION}
docker build . --file Dockerfile --tag ${DOCKER_REPO}:latest
docker push ${DOCKER_REPO}:latest
