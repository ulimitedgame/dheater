FROM nginx

MAINTAINER szilard.pfeiffer@balasys.hu

COPY dheat.victim.crt /etc/ssl/certs/
COPY dheat.victim.key /etc/ssl/private/

COPY nginx/ssl.conf /etc/nginx/conf.d/ssl.conf

ARG DHPARAM_FILE
COPY $DHPARAM_FILE /etc/ssl/certs/dhparam.pem
