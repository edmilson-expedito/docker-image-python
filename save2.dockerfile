FROM alpine:3.16

ENV PYTHON_VERSION 3.10.2

# install build dependencies and needed tools
RUN apk add \
    wget \
    gcc \
    make \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    musl-dev

# download and extract python sources
RUN cd /opt \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \                                              
    && tar xzf Python-${PYTHON_VERSION}.tgz

# build python and remove left-over sources
RUN cd /opt/Python-${PYTHON_VERSION} \ 
    && ./configure --prefix=/usr --enable-optimizations --with-ensurepip=install \
    && make install \
    && rm /opt/Python-${PYTHON_VERSION}.tgz /opt/Python-${PYTHON_VERSION} -rf

ENV PYTHON_PIP_VERSION 22.2.2
ENV PYTHON_SETUPTOOLS_VERSION 59.8.0
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/5eaac1050023df1f5c98b173b248c260023f2278/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 5aefe6ade911d997af080b315ebcb7f882212d070465df544e1175ac2be519b4

RUN set -eux; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum -c -; \
	\
	export PYTHONDONTWRITEBYTECODE=1; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		--no-compile \
		"pip==$PYTHON_PIP_VERSION" \
		"setuptools==$PYTHON_SETUPTOOLS_VERSION" \
	; \
	rm -f get-pip.py; \
	\
	pip --version

RUN apk add --no-cache bash

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

# CMD ["python3"]
CMD ["/bin/bash"]