FROM alpine:3.14

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3.10.2 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools