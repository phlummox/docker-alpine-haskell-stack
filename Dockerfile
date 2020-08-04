
# pinned on 4 aug 2020
FROM alpine:3.11.6@sha256:39eda93d15866957feaee28f8fc5adb545276a64147445c64992ef69804dbf01
MAINTAINER phlummox <docker-haskell-stack-maint@phlummox.dev>

RUN \
  apk update && \
  apk add \
        build-base \
        ca-certificates \
        curl \
        ghc \
        git \
        gmp-dev \
        sudo \
        xz \
        zlib-dev

#RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
#
#RUN \
#  apk update && \
#  apk add \
#        ghc@testing

ARG STACK_VERSION=2.1.3
ARG STACK_URL="https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz"

# build user
RUN adduser -g '' -D user && \
  adduser user abuild && \
  echo '%user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER user

RUN \
  mkdir -p /home/user/.local/bin

ENV PATH=/home/user/.local/bin:$PATH

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8  \
    LC_ALL=en_US.UTF-8

RUN \
  set -x; \
  curl -L ${STACK_URL} \
      | tar x -O -z "stack-${STACK_VERSION}-linux-x86_64-static/stack" \
      > /home/user/.local/bin/stack && \
  chmod a+rx /home/user/.local/bin/stack

ARG STACK_RESOLVER=lts-13
ARG STACK_ARGS="--resolver=${STACK_RESOLVER}"

# build command for static linking will porbably involve something like ...
# $ stack  --skip-ghc-check --system-ghc --resolver=lts-13  init
# OR
# $ stack --skip-ghc-check --system-ghc --resolver=lts-13 build  --ghc-options '-fPIC -optl -static' 


RUN : "pre-build a few packages" \
  stack --skip-ghc-check --system-ghc --resolver=lts-13 build  --ghc-options '-fPIC -optl -static' \
    cabal-install \
    cryptonite \
    mtl \
    shelly \
    unix

