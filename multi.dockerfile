FROM python:3.10-alpine3.16 as pythonBuilder
WORKDIR /home/dev/server
 # quaisquer dependências em python que requerem um código c/c++ compilado (se houver) 
RUN apk update && apk add --update gcc libc-dev linux -headers libusb-dev
 COPY ./home/dev/server .
RUN pip3 install --target=/home/dev/server/dependencies -r requirements.txt

FROM python:3.10-alpine3.16
WORKDIR /home/dev/server
 # inclui bibliotecas de tempo de execução (se houver) 
RUN apk update && apk add libusb-dev
 COPY --from=pythonBuilder /home/dev/server .
# ENV PYTHONPATH= "${PYTHONPATH}:/home/dev/server/dependencies" 
ENTRYPOINT ["/bin/sh"]