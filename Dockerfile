FROM node:12-alpine3.12

# common build flags
ENV CFLAGS=-O3
ENV CXXFLAGS=-O3

ARG VIPS_VERSION=8.11.3

RUN set -x -o pipefail \
    && wget -O- https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | tar xzC /tmp \
    && apk update \
    && apk upgrade \
    && apk add \
     libjpeg-turbo libpng tiff librsvg libgsf libimagequant \
    && apk add --virtual vips-dependencies build-base \
     libjpeg-turbo-dev libpng-dev tiff-dev librsvg-dev libgsf-dev libimagequant-dev \
    && cd /tmp/vips-${VIPS_VERSION} \
    && ./configure --prefix=/usr \
                   --disable-static \
                   --disable-dependency-tracking \
                   --enable-silent-rules \
    && make -s install-strip \
    && cd $OLDPWD \
    && rm -rf /tmp/vips-${VIPS_VERSION} \
    && apk del --purge vips-dependencies \
    && rm -rf /var/cache/apk/*
    
