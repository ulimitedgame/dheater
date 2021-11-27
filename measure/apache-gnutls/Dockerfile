FROM httpd

MAINTAINER szilard.pfeiffer@balasys.hu

COPY dheat.victim.crt /etc/ssl/certs/
COPY dheat.victim.key /etc/ssl/private/

COPY apache-gnutls/apt-gnutls.list /etc/apt/sources.list.d/
RUN apt-get update
RUN apt-get install -y libapache2-mod-gnutls
RUN ln -s /usr/lib/apache2/modules/mod_gnutls.so /usr/local/apache2/modules/

COPY apache-gnutls/ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
RUN sed -i 's%^#\([A-Z].*ssl.*\)$%\1%' /usr/local/apache2/conf/httpd.conf 
RUN sed -i 's%ssl_module modules/mod_ssl%gnutls_module modules/mod_gnutls%' /usr/local/apache2/conf/httpd.conf 

ARG DHPARAM_FILE
RUN echo $DHPARAM_FILE | sed 's%[^0-9]*\([0-9]\+\).*%:-GROUP-FFDHE\1%' | xargs -I '{}' sed -i 's%{}%%' /usr/local/apache2/conf/extra/httpd-ssl.conf
