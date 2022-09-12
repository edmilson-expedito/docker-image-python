FROM alpine:3.16

ENV PATH /usr/local/bin:$PATH
ENV PYTHON_VERSION 3.10.2
ENV PYTHON_PIP_VERSION 22.2.2
ENV PYTHON_SETUPTOOLS_VERSION 63.2.0
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/5eaac1050023df1f5c98b173b248c260023f2278/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 5aefe6ade911d997af080b315ebcb7f882212d070465df544e1175ac2be519b4
ENV LANG C.UTF-8

RUN set -eux; \ 	
	apk add --no-cache	ca-certificates	tzdata;

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
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
		zlib-dev \
	; \
	wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"; \
	mkdir -p /usr/src/python; \
	tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz; \
	rm python.tar.xz; \
	cd /usr/src/python; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-lto \
		--with-system-expat \
		--without-ensurepip \
	; \
	make install;

RUN set -eux; \
	for src in idle3 pydoc3 python3 python3-config; do \
		dst="$(echo "$src" | tr -d 3)"; \
		[ -s "/usr/local/bin/$src" ]; \
		[ ! -e "/usr/local/bin/$dst" ]; \
		ln -svT "$src" "/usr/local/bin/$dst"; \
	done

RUN set -eux; \
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum -c -; \
	export PYTHONDONTWRITEBYTECODE=1; \
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		--no-compile \
		"pip==$PYTHON_PIP_VERSION" \
		"setuptools==$PYTHON_SETUPTOOLS_VERSION" \
	; \
	rm -f get-pip.py;

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
    py3-pyqt-builder \
    py3-sip \
    py3-pip

COPY ./server/ /home/dev/server/

WORKDIR /home/dev/server

EXPOSE 8000

# ENTRYPOINT ["/bin/sh"]