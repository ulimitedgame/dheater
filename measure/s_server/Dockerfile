FROM debian:stable-slim

MAINTAINER szilard.pfeiffer@balasys.hu

RUN apt-get update
RUN apt-get install -y --no-install-recommends openssl

WORKDIR /root

COPY s_server/run.sh run.sh

COPY dheat.victim.crt /root
COPY dheat.victim.key /root

RUN cat dheat.victim.* >>server.pem

ARG DHPARAM_FILE
COPY $DHPARAM_FILE /root/dhparam.pem

RUN cat dhparam.pem >>server.pem

CMD ["./run.sh"]
