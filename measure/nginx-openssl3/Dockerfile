FROM ubuntu:22.04

MAINTAINER szilard.pfeiffer@balasys.hu

RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx

COPY dheat.victim.crt /etc/ssl/certs/
COPY dheat.victim.key /etc/ssl/private/

COPY nginx-openssl3/ssl.conf /etc/nginx/sites-enabled/ssl.conf

ENTRYPOINT nginx -g 'daemon off;'
