FROM httpd

MAINTAINER szilard.pfeiffer@balasys.hu

COPY dheat.victim.crt /etc/ssl/certs/
COPY dheat.victim.key /etc/ssl/private/

COPY apache/ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
RUN sed -i 's%^#\([A-Z].*ssl.*\)$%\1%' /usr/local/apache2/conf/httpd.conf 

ARG DHPARAM_FILE
COPY $DHPARAM_FILE /root/
RUN cat /root/$DHPARAM_FILE >>/etc/ssl/certs/dheat.victim.crt
