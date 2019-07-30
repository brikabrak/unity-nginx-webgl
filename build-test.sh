#!/bin/bash
#
# unity-nginx-webgl
#
# Copyright (C) 2019 Blake Farrugia
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
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

cd "$(dirname "$0")"

# Base variables
PORT=8080
BUILD_PATH="Builds/"
BUILD_DIR="test"
CONTAINER_NAME=""
USE_FULL_PATH=false

usage() {
    cat << USE
unity-nginx-webgl - Copyright (C) 2019 Blake Farrugia

<---> <---> <---> <---> <---> <---> <---> <---> <---> <---> <---> <--->
This program comes with ABSOLUTELY NO WARRANTY. This is free software,
and you are welcome to redistribute it under certain conditions.

See details in attached GNU GPLv3 LICENSE file.
<---> <---> <---> <---> <---> <---> <---> <---> <---> <---> <---> <--->

Usage: ./$(basename -- "$0") [--options]

Options:
    -h|--help
    -c|--clean
    -p|--port port-number
    -d|--target-dir build-directory
    -f|--full-target-path some/path/to/build-target
        Note: -f overrides -d argument

USE
}

fullBuildPath() {
    echo $BUILD_PATH$BUILD_DIR
}

cleanInstances() {
    docker rm $(docker stop $(docker ps -a --filter ancestor=unity-webgl -q 2>/dev/null ) 2>/dev/null) >&/dev/null 
    docker rmi -f $(docker images -a --filter=reference='unity-webgl*' -q 2>/dev/null ) >&/dev/null
}

# Argument-parsing examples courtesy of StackOverflow
# https://stackoverflow.com/a/35235757
args=( )
for arg; do
    case "$arg" in
        --name) args+=( -n ) ;;
        --clean) args+=( -c ) ;;
        --port) args+=( -p ) ;;
        --full-target-path) args+=( -f ) ;;
        --build-path) args+=( -b ) ;;
        --target-dir) args+=( -d ) ;;
        --help) args+=( -h ) ;;
        *) args+=( "$arg" ) ;;
    esac
done

set -- "${args[@]}"

while getopts ":hn:p:f:b:d:" OPTION; do
    case $OPTION in
        n) CONTAINER_NAME="$OPTARG" ;;
        c) cleanInstances && exit 0 ;;
        p) PORT=$OPTARG ;;
        f|b) BUILD_PATH=$OPTARG
            [[ "$OPTION" = f ]] && USE_FULL_PATH=true && BUILD_DIR=""
            ;;
        d) [[ "$USE_FULL_PATH" = false ]] && BUILD_DIR=$OPTARG || echo "Using full path, disregarding target directory";;
        h) usage && exit 0 ;;
        \?) echo "Unknown option. Use --help" 1>&2 && exit 1 ;;
        :) echo "Missing argument: $OPTARG requires argument" 1>&2 && exit 1 ;;
    esac
done

[[ ! -d $(fullBuildPath) ]] && echo "Target directory $(fullBuildPath) does not exist." 1>&2 && exit 1
[[ "$CONTAINER_NAME" = "" ]] && CONTAINER_NAME=$(basename $(fullBuildPath))

# Stop and remove existing containers and images
cleanInstances

# Build via Buildkit so it likes our .dockerignore
DOCKER_BUILDKIT=1 docker build -t unity-webgl --build-arg BUILD_DIR=$(fullBuildPath) .
UNITY_DOCKER_ID=$(docker run --name $CONTAINER_NAME -d -p $PORT:80 unity-webgl)

[[ ! $(docker top $UNITY_DOCKER_ID) ]] && echo "There was an issue deploying..." && exit 1

echo
echo "All set. Go to localhost:$PORT to begin testing." && exit 0
