FROM ubuntu:22.04

MAINTAINER szilard.pfeiffer@balasys.hu

ARG MOD_SSL

RUN apt-get update
RUN apt-get install -y --no-install-recommends lighttpd lighttpd-mod-$MOD_SSL

COPY dheat.victim.crt  /etc/lighttpd/server.crt
COPY dheat.victim.key /etc/lighttpd/server.key

COPY dheat.ca.crt .
RUN cat dheat.ca.crt >>/etc/lighttpd/server.crt

COPY lighttpd-openssl3/ssl.conf.in /etc/lighttpd/conf-enabled/ssl.conf
RUN sed -i "s%mod_MOD_SSL%mod_$MOD_SSL%" /etc/lighttpd/conf-enabled/ssl.conf

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
