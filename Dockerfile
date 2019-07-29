FROM nginx:stable

ARG BUILD_DIR=Builds/release
ADD $BUILD_DIR /usr/share/nginx/html

EXPOSE 80
