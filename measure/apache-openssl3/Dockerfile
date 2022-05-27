FROM ubuntu:22.04

MAINTAINER szilard.pfeiffer@balasys.hu

RUN apt-get update && \
    apt-get install -y --no-install-recommends apache2

COPY dheat.victim.crt /etc/ssl/certs/
COPY dheat.victim.key /etc/ssl/private/

COPY apache-openssl3/ssl.conf /etc/apache2/sites-enabled/httpd-ssl.conf

RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/

ENTRYPOINT apachectl -D FOREGROUND
