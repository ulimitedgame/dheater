FROM debian:bullseye-slim

MAINTAINER szilard.pfeiffer@balasys.hu

RUN mkdir /run/sshd

RUN apt-get update
RUN apt-get install -y --no-install-recommends openssh-server

COPY openssh/kex-algorithm.sh /kex-algorithm.sh
COPY openssh/entry.sh /entry.sh

ARG DH_PARAM_SIZE
RUN echo -n "KexAlgorithms " >/etc/ssh/sshd_config.d/kex_algorithms.conf
RUN ./kex-algorithm.sh $DH_PARAM_SIZE >>/etc/ssh/sshd_config.d/kex_algorithms.conf

RUN echo "MaxStartups 1000:1:1000" >/etc/ssh/sshd_config.d/max-startups.conf

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D"]
