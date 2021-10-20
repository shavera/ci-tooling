FROM ubuntu

RUN apt-get update
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get -qqy install apt-utils tzdata

RUN apt-get -qqy install \
    build-essential \
    curl \
    gcovr \
    gpg \
    openjdk-11-jre \
    ninja-build \
    unzip \
    wget

# SOURCE_DIR, BUILD_DIR, COVERAGE_DIR are paths inside the container
# It is assumed that these paths will be volumes mounted to the container
# so these env vars should be overridden with RUN
ENV SOURCE_DIR=""
ENV BUILD_DIR=""
ENV COVERAGE_DIR=""
ENV TOOLING_DIR="/usr/local/bin/ci-tooling"

#install cmake from kitware apt repo
WORKDIR /tmp/kitware
RUN wget https://apt.kitware.com/kitware-archive.sh && \
    chmod +x kitware-archive.sh && \
    ./kitware-archive.sh && \
    apt-get -qqy install cmake

# Install SonarScanner & Build Wrapper
ENV SONAR_SERVER_URL="https://sonarcloud.io"
ENV SONAR_SCANNER_VERSION=4.6.1.2450
ENV SONAR_SCANNER_DOWNLOAD_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip
ENV BUILD_WRAPPER_DOWNLOAD_URL=${SONAR_SERVER_URL}/static/cpp/build-wrapper-linux-x86.zip
ENV BUILD_WRAPPER_OUT_DIR=/usr/sonar/build_wrapper_output
WORKDIR /usr/.sonar
RUN curl -sSLo /usr/.sonar/sonar-scanner.zip ${SONAR_SCANNER_DOWNLOAD_URL} && \
    unzip -o /usr/.sonar/sonar-scanner.zip -d /usr/.sonar && \
    curl -sSLo /usr/.sonar/build-wrapper-linux-x86.zip ${BUILD_WRAPPER_DOWNLOAD_URL} && \
    unzip -o /usr/.sonar/build-wrapper-linux-x86.zip -d /usr/.sonar

ENV PATH="/usr/.sonar/build-wrapper-linux-x86:/usr/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux/bin:${PATH}"

# When running sonar scan phase, will need to specify SONAR_TOKEN
ENV SONAR_TOKEN=""

#install our several build phase scripts
WORKDIR $TOOLING_DIR
COPY scripts/* $TOOLING_DIR
RUN chmod +x "${TOOLING_DIR}/*"

ENTRYPOINT ["${TOOLING_DIR}/metabuild.sh"]
