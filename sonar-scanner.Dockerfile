FROM local/project-base

RUN apt-get -qqy install \
    curl \
    openjdk-11-jre \
    unzip

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

# Assumes an environment variable SOURCE_DIR and SONAR_TOKEN will be updated when container is run
ENV SOURCE_DIR=""
ENV SONAR_TOKEN=""
ENV BUILD_DIR=""
ENV COVERAGE_DIR=""
COPY scripts/sonarscan.sh /usr/bin/
RUN chmod +x /usr/bin/sonarscan.sh
ENTRYPOINT sonarscan.sh
