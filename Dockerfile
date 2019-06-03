FROM debian:stretch

MAINTAINER etimmons@mit.edu

ENV LANG=C.UTF-8

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu dirmngr gnupg; \
    rm -rf /var/lib/apt/lists/*;

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
       build-essential \
       openjdk-8-jre-headless \
    && apt-get purge -y --auto-remove wget \
    && rm -rf /var/lib/apt/lists/* \
    && cp -a /etc/skel /home/lisp

COPY assets/lisp-installers /tmp/lisp-installers

ENV SBCL_VERSION=1.5.3 CCL_VERSION=1.11.5 ECL_VERSION=16.1.3 ABCL_VERSION=1.5.0

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
