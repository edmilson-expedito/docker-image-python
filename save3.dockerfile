FROM alpine:3.16

ENV PYTHON_VERSION 3.10.2

RUN set -eux;

RUN	apk add --no-cache --virtual .build-deps \
		build-base \
		wget \
		tar \
		xz \
		bzip2-dev \
		dpkg-dev dpkg \
		expat-dev \
		findutils \
		gdbm-dev \
		libc-dev \
		libffi-dev \
		libnsl-dev \
		libtirpc-dev \
		linux-headers \
		make \
		ncurses-dev \
		openssl-dev \
		pax-utils \
		readline-dev \
		sqlite-dev \
		tcl-dev \
		tk \
		tk-dev \
		util-linux-dev \
		xz-dev \
		zlib-dev;

RUN cd /opt \
	&& wget "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& tar -xf Python-$PYTHON_VERSION.tar.xz

RUN cd /opt/Python-$PYTHON_VERSION \
	&& ./configure --prefix=/usr --enable-optimizations --with-ensurepip=install \
	&& make install \
	&& rm /opt/Python-$PYTHON_VERSION.tar.xz /opt/Python-$PYTHON_VERSION -rf

RUN apk --no-cache add \
    build-base \
    cmake \
    openblas \
    gfortran \
    lapack \
    libstdc++ \
    musl-dev \
    lapack-dev \
    openblas \
    libc-dev \
    mpc1-dev \
    postgresql-dev \
    postgresql \
    postgresql-contrib \
    git-crypt \
    graphviz \
    graphviz-dev \
    py3-wheel \
    jack-example-clients \
    py3-wheel-doc \
    py3-sip \
    py3-pip

COPY ./app/ /home/dev/server/

WORKDIR /home/dev/server

EXPOSE 8000