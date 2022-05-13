FROM balasys/dheater:measure-https-tomcat-openjdk7-ffdhe

MAINTAINER szilard.pfeiffer@balasys.hu

RUN apt-get update
RUN apt-get install -y --no-install-recommends wget ca-certificates
RUN wget https://download.oracle.com/java/18/latest/jdk-18_linux-x64_bin.deb
RUN apt-get install -y --no-install-recommends ./jdk-18_linux-x64_bin.deb
RUN apt-get purge -y wget
RUN rm ./jdk-18_linux-x64_bin.deb

WORKDIR /srv/mutual-tls-ssl/server
ENV JAVA_HOME /usr/lib/jvm/jdk-18/
CMD ["../mvnw", "spring-boot:run"]
