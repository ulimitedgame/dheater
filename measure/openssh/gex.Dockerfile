FROM debian:bullseye-slim

MAINTAINER szilard.pfeiffer@balasys.hu

RUN mkdir /run/sshd

RUN apt-get update
RUN apt-get install -y --no-install-recommends openssh-server

COPY openssh/entry.sh /entry.sh

RUN echo "KexAlgorithms diffie-hellman-group-exchange-sha256" >/etc/ssh/sshd_config.d/kex_algorithms.conf
RUN sed -E -i '/ (2047|4095|8191) /d' /etc/ssh/moduli

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D"]
