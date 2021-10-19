FROM local/project-builder

RUN apt-get -qqy install gcovr

# Should set this directory when called
# Should inherit source, build dirs from project-builder
# (i.e. will need them to be set at run time as well)
ENV COVERAGE_DIR=""
COPY scripts/unit-test.sh /usr/bin/
RUN chmod +x /usr/bin/unit-test.sh
