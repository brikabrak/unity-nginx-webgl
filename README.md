# unity-nginx-webgl

## Synopsis

This repository provides a barebones `Dockerfile` to use for testing Unity WebGL builds locally without reliance on an outside server. The `build.test.sh` script allows for several path and directory options.

This docker will build an underlying Nginx system. There have been no additional features put in place to modify the base Nginx configuration. Host machine access will be through `localhost` at the preferred port.

This is a personal project for helping to test local WebGL builds without additional server costs and is given as-is. For more licensing information, please peruse the `GNU GPLv3 LICENSE` file included.

## Usage

- Build your Unity project for WebGL into desired location (e.g. Builds/test-project-build)
- Clone repository into either a separate directory, or instance within root Unity project directory as a git submodule. Repository can also live in Unity project under bin or lib directories.
- Run `./build-test.sh -n my-test-container -p 8123 -d your-test-project-build-directory`.
- Docker will build the `unity-webgl` image, then the docker container named `my-test-container` will be ran. If name is not provided, the build directory's name will be used.
- Pop open your favorite browser and load up `localhost:your-chosen-port` (e.g. `localhost:8123`)
