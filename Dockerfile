FROM debian:jessie

MAINTAINER etimmons@mit.edu

ENV LANG=C.UTF-8

# Install tools that will be needed even after build time.
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    # Needed by ECL to compile lisp files and used by CFFI (used commonly enough
    # that it should stay)
    build-essential \
    openjdk-7-jre-headless \
    && apt-get clean \
    && rm -rf /var/lib/apt \
    && adduser --gecos "Lisp User" --disabled-password lisp

COPY assets/lisp-installers /tmp/lisp-installers

ENV SBCL_VERSION=1.3.2 CCL_VERSION=1.11 ECL_VERSION=16.0.0 ABCL_VERSION=1.3.3

RUN chmod +x /tmp/lisp-installers/* \
    && sync \
    && sleep 2 \
    && /tmp/lisp-installers/init \
    && /tmp/lisp-installers/sbcl.install \
    && /tmp/lisp-installers/abcl.install \
    && /tmp/lisp-installers/ccl.install \
    && /tmp/lisp-installers/ecl.install \
    && /tmp/lisp-installers/clean \
    && rm -rf /tmp/lisp-installers

# Set up folders and volumes.
RUN mkdir -p /etc/common-lisp/asdf-output-translations.conf.d \
    && mkdir -p /etc/common-lisp/source-registry.conf.d \
    && mkdir -p /var/cache/common-lisp \
    && chmod 1777 /var/cache/common-lisp \
    && mkdir -p /usr/local/share/common-lisp/slime \
    && mkdir -p /usr/local/share/common-lisp/source \
    && chmod 1777 /usr/local/share/common-lisp/source

COPY assets/asdf/50-default-translations.conf /etc/common-lisp/asdf-output-translations.conf.d/
COPY assets/asdf/50-slime.conf /etc/common-lisp/source-registry.conf.d/

VOLUME ["/usr/local/share/common-lisp/slime"]

USER lisp
