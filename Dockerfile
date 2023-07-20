#
# Builder
#
FROM node:16 AS builder

WORKDIR /app

COPY ./server/package.json ./server/yarn.lock ./server/tsconfig.json ./

RUN yarn install --frozen-lockfile

COPY ./server .

RUN yarn build

#
# Client Builder
#
FROM ubuntu:20.04 AS client-builder

ARG DEBIAN_FRONTEND=noninteractive

ARG API_AUTHORITY

RUN apt-get update && apt-get install -y curl git wget unzip fonts-droid-fallback python3
RUN apt-get clean

RUN apt-get update && apt-get install -y build-essential
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /usr/local/flutter

RUN flutter channel master

RUN flutter upgrade

RUN flutter config --enable-web

WORKDIR /app

COPY ./client .

RUN flutter pub get

RUN flutter build web --release --dart-define API_AUTHORITY=${API_AUTHORITY}

#
# Runner
#
FROM node:16

WORKDIR /app

COPY ./server/package.json ./server/yarn.lock ./server/tsconfig.json ./

COPY --from=builder /app/build /app/build
COPY --from=client-builder /app/build/web /app/public

RUN yarn install --production --frozen-lockfile

CMD [ "node", "build/index.js" ]
