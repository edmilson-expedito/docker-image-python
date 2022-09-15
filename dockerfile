FROM alpine:3.16 as build

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
		cmake \
		openblas \
		gfortran \
		lapack \
		libstdc++ \
		musl-dev \
		lapack-dev \
		openblas \
		mpc1-dev \
		postgresql-dev \
		postgresql \
		postgresql-contrib \
		git-crypt \
		graphviz \
		graphviz-dev \
		jack-example-clients \
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

FROM build as pythonInstall

ENV PYTHON_VERSION 3.10.2

WORKDIR /opt
RUN	wget "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" 
RUN	tar -xf Python-$PYTHON_VERSION.tar.xz

WORKDIR /opt/Python-$PYTHON_VERSION
RUN	./configure --prefix=/usr --enable-optimizations --with-ensurepip=install
RUN	make install
RUN make altinstall
RUN	rm -rf Python-$PYTHON_VERSION*

# RUN	apk del .build-deps

RUN apk add --no-cache \
		py3-wheel \
		py3-wheel-doc \
		py3-sip \
		py3-pip;

FROM pythonInstall as application

WORKDIR /home/dev/server

ENV SERVICE_USER=container-user
ENV SERVICE_USER_ID=1001

RUN	addgroup --gid $SERVICE_USER_ID -S $SERVICE_USER
RUN adduser -G $SERVICE_USER --shell /bin/false --home /home/dev/server \
		--disabled-password -H --uid $SERVICE_USER_ID $SERVICE_USER
RUN chown $SERVICE_USER:$SERVICE_USER -R /home/dev/server
RUN chmod 777 -R /home/dev/server

RUN python3 -m pip install uvicorn

USER $SERVICE_USER

COPY ./server/ /home/dev/server/

RUN	pip3 install -r requirements.txt 
# RUN	pip3 freeze > /home/dev/server/requirements.txt	

FROM application

EXPOSE 8000
EXPOSE 8080

WORKDIR /home/dev/server

ENTRYPOINT ["python3"]
# CMD [ "--version" ]
CMD ["-m", "uvicorn", "app:app", "--reload", "--host", "0.0.0.0"]