FROM debian:bullseye-slim

MAINTAINER szilard.pfeiffer@balasys.hu

RUN apt-get update
RUN apt-get install -y --no-install-recommends ucspi-tcp dropbear

CMD ["dropbear", "-F", "-E"]
