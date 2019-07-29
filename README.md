# unity-nginx-webgl

## Synopsis

This repository provides a barebones `Dockerfile` to use for testing Unity WebGL builds locally without reliance on an outside server. The `build.test.sh` script allows for several path and directory options.

This docker will build an underlying Nginx system. There have been no additional features put in place to modify the base Nginx configuration. Host machine access will be through `localhost` at the preferred port.

This is a personal project for helping to test local WebGL builds without additional server costs and is given as-is. For more licensing information, please peruse the `MIT License` included.

## Usage

- Build your Unity project for WebGL into desired location (e.g. Builds/test-project-build)
- After cloning the repository, copy the `.dockerignore`, `Dockerfile`, and `build-test.sh` scripts to your root project directory.
- Run `build-test.sh -n my-test-container -p 8123 -d test-project-build`
- Docker will build the `unity-webgl` image, then the docker container named `my-test-container` will be ran. If name is not provided, the build directory's name will be used.
- Pop open your favorite browser and load up `localhost:your-chosen-port` (e.g. `localhost:8123`)
