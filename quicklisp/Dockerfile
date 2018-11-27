FROM daewok/lisp-devel:base
MAINTAINER etimmons@mit.edu

RUN echo "deb http://httpredir.debian.org/debian stretch-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && (apt-get install --no-install-recommends -y \
                libcairo2-dev libffi-dev \
                libsdl1.2-dev libsdl-gfx1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev \
                libgtkglext1-dev \
                freeglut3-dev libalut-dev libhdf5-dev libgtk-3-dev \
                libuv1-dev python-dev libgsl0-dev \
                libncurses-dev libdevil-dev libfam-dev \
                libfcgi-dev firebird-dev libfuse-dev libsqlite3-dev \
                libgeoip-dev libgit2-dev libglfw3-dev libftgl2 libgraphviz-dev \
                libkrb5-dev libfixposix-dev libkyotocabinet-dev liballegro5-dev \
                liballegro-acodec5-dev liballegro-audio5-dev liballegro-dialog5-dev \
                liballegro-image5-dev liballegro-physfs5-dev liballegro-ttf5-dev \
                libevent-dev liblinear-dev libpuzzle-dev libsvm-dev libusb-dev \
                libyaml-dev default-libmysqlclient-dev libplplot-dev libportaudio2 \
                libproj-dev pslib-dev librabbitmq-dev r-mathlib liblapack-dev \
                librrd-dev libtesseract-dev libtidy-dev libtokyocabinet-dev \
                libev-dev libassimp-dev libfreeimage-dev libode-dev libcsnd-dev \
                libenchant-dev libsdl2-dev libqt4-dev cmake libsmokeqt4-dev libnet-dev \
                libsdl-ttf2.0-dev libczmq-dev libmpg123-dev libmagic-dev freetds-dev \
                libfann-dev libglpk-dev libpapi-dev unixodbc-dev libpcap-dev \
                r-base-dev libsane-dev swig libsnappy-dev graphviz gnuplot \
        || apt-get install --no-install-recommends -y \
                libcairo2-dev libffi-dev \
                libsdl1.2-dev libsdl-gfx1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev \
                libgtkglext1-dev \
                freeglut3-dev libalut-dev libhdf5-dev libgtk-3-dev \
                libuv1-dev python-dev libgsl0-dev \
                libncurses-dev libdevil-dev libfam-dev \
                libfcgi-dev firebird-dev libfuse-dev libsqlite3-dev \
                libgeoip-dev libgit2-dev libglfw3-dev libftgl2 libgraphviz-dev \
                libkrb5-dev libfixposix-dev libkyotocabinet-dev liballegro5-dev \
                liballegro-acodec5-dev liballegro-audio5-dev liballegro-dialog5-dev \
                liballegro-image5-dev liballegro-physfs5-dev liballegro-ttf5-dev \
                libevent-dev liblinear-dev libpuzzle-dev libsvm-dev libusb-dev \
                libyaml-dev default-libmysqlclient-dev libplplot-dev libportaudio2 \
                libproj-dev pslib-dev librabbitmq-dev r-mathlib liblapack-dev \
                librrd-dev libtesseract-dev libtidy-dev libtokyocabinet-dev \
                libev-dev libassimp-dev libfreeimage-dev libode-dev libcsnd-dev \
                libenchant-dev libsdl2-dev libqt4-dev cmake libsmokeqt4-dev libnet-dev \
                libsdl-ttf2.0-dev libczmq-dev libmpg123-dev libmagic-dev freetds-dev \
                libfann-dev libglpk-dev libpapi-dev unixodbc-dev libpcap-dev \
                r-base-dev libsane-dev swig libsnappy-dev graphviz gnuplot ) \
    && apt-get clean \
    && rm -rf /var/lib/apt \
    && ln -s /usr/lib/libcsnd6.so /usr/lib/libcsnd.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libgtk-x11-2.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libgdk-x11-2.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libatk-1.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libm.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libpangoxft-1.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libpangox-1.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libpango-1.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libgobject-2.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libgmodule-2.0.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libdl.so /usr/lib \
    && ln -s /usr/lib/x86_64-linux-gnu/libglib-2.0.so /usr/lib

RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt \
    && curl "https://beta.quicklisp.org/release-key.txt" > /tmp/quicklisp-release-key.txt \
    && curl "https://beta.quicklisp.org/quicklisp.lisp" > /tmp/quicklisp.lisp \
    && curl "https://beta.quicklisp.org/quicklisp.lisp.asc" > /tmp/quicklisp.lisp.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --import /tmp/quicklisp-release-key.txt \
    && gpg --batch --verify /tmp/quicklisp.lisp.asc /tmp/quicklisp.lisp \
    && sync \
    && sleep 2 \
    && rm -rf "$GNUPGHOME" /tmp/quicklisp.lisp.asc \
    && export HOME=/home/lisp \
    && sbcl --no-sysinit --no-userinit --non-interactive \
            --load /tmp/quicklisp.lisp \
            --eval "(quicklisp-quickstart:install)" \
            --eval "(ql::without-prompting (dolist (imp '(:sbcl :ccl :abcl :ecl)) (ql:add-to-init-file imp)))" \
    && rm -rf /tmp/*
