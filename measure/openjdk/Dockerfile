FROM debian:stable-slim

MAINTAINER szilard.pfeiffer@balasys.hu

RUN apt-get update
RUN apt-get install -y --no-install-recommends git-core maven

RUN git clone https://github.com/Hakky54/mutual-tls-ssl.git /srv/mutual-tls-ssl

COPY dheat.victim.crt  .
COPY dheat.victim.key .
RUN openssl pkcs12 -export -out dheat.victim.pkcs12 -in dheat.victim.crt -inkey dheat.victim.key -password pass:secret
RUN keytool -v -importkeystore -srcstorepass secret -srckeystore dheat.victim.pkcs12 -srcstoretype PKCS12 -destkeystore /srv/mutual-tls-ssl/shared-server-resources/src/main/resources/identity.jks -deststoretype JKS -storepass secret

WORKDIR /srv/mutual-tls-ssl
RUN mvn install -pl server -am

COPY openjdk/ssl.yml .
RUN cat ssl.yml >>server/target/classes/application.yml

WORKDIR /srv/mutual-tls-ssl/server
CMD ["../mvnw", "spring-boot:run"]
