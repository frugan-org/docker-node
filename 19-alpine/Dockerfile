FROM node:19-alpine

#https://docs.strapi.io/dev-docs/installation/docker
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache \
    autoconf \
    automake \
    bash \
    build-base \
    ca-certificates \
    curl \
    gcc \
    git \
    libpng-dev \
    nasm \
    vips-dev \
    zlib-dev \
;

RUN npm install -g node-gyp
RUN npm config set fetch-retry-maxtimeout 600000 -g


####

WORKDIR /opt/app

COPY entrypoint.sh /

#https://github.com/docker-library/postgres/issues/296#issuecomment-308735942
RUN chmod +x /entrypoint.sh

#USER node
EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node"]
