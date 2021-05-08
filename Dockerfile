FROM node:12-alpine3.12

# common build flags
ENV CFLAGS=-O3
ENV CXXFLAGS=-O3

ARG VIPS_VERSION=8.10.6

RUN set -x -o pipefail \
    && wget -O- https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | tar xzC /tmp \
    && apk update \
    && apk upgrade \
    && apk add \
     zlib libxml2 glib gobject-introspection \
     libjpeg-turbo libexif lcms2 fftw giflib libpng \
     libwebp orc tiff poppler-glib librsvg libgsf openexr \
     libheif libimagequant pango tzdata\
    && apk add --virtual vips-dependencies build-base \
     zlib-dev libxml2-dev glib-dev gobject-introspection-dev \
     libjpeg-turbo-dev libexif-dev lcms2-dev fftw-dev giflib-dev libpng-dev \
     libwebp-dev orc-dev tiff-dev poppler-dev librsvg-dev libgsf-dev openexr-dev \
     libheif-dev libimagequant-dev pango-dev \
     py-gobject3-dev \
    && cd /tmp/vips-${VIPS_VERSION} \
    && ./configure --prefix=/usr \
                   --disable-static \
                   --disable-dependency-tracking \
                   --enable-silent-rules \
    && make -s install-strip \
    && cd $OLDPWD \
    && rm -rf /tmp/vips-${VIPS_VERSION} \
    && apk del --purge vips-dependencies \
    && rm -rf /var/cache/apk/* \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
