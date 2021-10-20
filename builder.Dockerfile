FROM ubuntu

RUN apt-get update
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get -qqy install apt-utils tzdata

RUN apt-get -qqy install \
    build-essential \
    gpg \
    ninja-build \
    wget

#install cmake from kitware apt repo
WORKDIR /tmp/kitware
RUN wget https://apt.kitware.com/kitware-archive.sh && \
    chmod +x kitware-archive.sh && \
    ./kitware-archive.sh && \
    apt-get -qqy install cmake

WORKDIR /usr
COPY scripts/build-project.sh /usr/bin/
RUN chmod +x /usr/bin/build-project.sh

# SOURCE_DIR and BUILD_DIR should be specified with the run
# They are assumed to be volumes mounted to some location
ENV SOURCE_DIR=""
ENV BUILD_DIR=""
ENTRYPOINT build-project.sh