FROM ubuntu

RUN apt-get update
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get -qqy install apt-utils tzdata
