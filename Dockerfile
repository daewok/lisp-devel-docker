FROM debian:stretch

MAINTAINER etimmons@mit.edu

ENV LANG=C.UTF-8

ENV GOSU_VERSION 1.10
RUN set -ex; \
    \
    fetchDeps=' \
        ca-certificates \
        wget \
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps dirmngr gpg; \
    rm -rf /var/lib/apt/lists/*; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    sync; \
    sleep 2; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
    chmod +x /usr/local/bin/gosu; \
# verify that the binary works
    gosu nobody true; \
    \
    apt-get purge -y --auto-remove $fetchDeps

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
       build-essential \
       openjdk-8-jre-headless \
    && apt-get purge -y --auto-remove wget \
    && rm -rf /var/lib/apt/lists/* \
    && cp -a /etc/skel /home/lisp

COPY assets/lisp-installers /tmp/lisp-installers

ENV SBCL_VERSION=1.4.2 CCL_VERSION=1.11 ECL_VERSION=16.1.3 ABCL_VERSION=1.5.0

RUN chmod +x /tmp/lisp-installers/* \
    && sync \
    && sleep 2 \
    && /tmp/lisp-installers/init \
    && /tmp/lisp-installers/sbcl.install \
    && /tmp/lisp-installers/abcl.install \
    && /tmp/lisp-installers/ccl.install \
    && /tmp/lisp-installers/ecl.install \
    && /tmp/lisp-installers/clean \
    && rm -rf /tmp/*

# Set up folders and volumes.
RUN mkdir -p /etc/common-lisp/asdf-output-translations.conf.d \
    && mkdir -p /etc/common-lisp/source-registry.conf.d \
    && mkdir -p /usr/local/share/common-lisp/slime \
    && mkdir -p /usr/local/share/common-lisp/source \
    && chmod 777 /usr/local/share/common-lisp/source

COPY assets/asdf/50-slime.conf /etc/common-lisp/source-registry.conf.d/
COPY assets/entrypoint.sh /usr/local/bin/daewok_lisp-docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/daewok_lisp-docker_entrypoint.sh"]
