#!/usr/bin/env bash

# USAGE: environment variable BUILD_PHASE should be set to one of: [BUILD|TEST|SCAN]
# BUILD - build the project
# TEST - run unit tests, generate coverage report
# SCAN - run sonar scanner
# Note: script is not smart, it assumes these are run in the correct order

_build(){
  if [[ ! -d "${SOURCE_DIR}" ]]; then
    echo "No directory specified by SOURCE_DIR ${SOURCE_DIR} exists."
    exit 1
  fi

  if [[ ! -d "${BUILD_DIR}" ]]; then
    BUILD_DIR="${SOURCE_DIR}/build"
    echo "No valid build directory specified, creating it as ${BUILD_DIR}"
    mkdir -p BUILD_DIR
  fi

  cmake -G Ninja -DBUILD_CODE_COVERAGE=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -S "${SOURCE_DIR}" -B "${BUILD_DIR}"
  cmake --build "${BUILD_DIR}" --target all
}

_test(){
  if [[ ! -d "${BUILD_DIR}" ]]; then
    echo "No directory specified by BUILD_DIR exists. BUILD_DIR=${BUILD_DIR}"
    exit 1
  fi

  if [[ ! -d "${COVERAGE_DIR}" ]]; then
    echo "No directory specified by COVERAGE_DIR exists. COVERAGE_DIR=${COVERAGE_DIR}"
    exit 1
  fi

  ctest --test-dir "${BUILD_DIR}" --no-tests=error

  gcovr --sonarqube "${COVERAGE_DIR}/coverage.xml"
}

_scan(){
  COMPILE_COMMANDS_FILE="${BUILD_DIR}/compile_commands.json"
  COVERAGE_FILE="${COVERAGE_DIR}/coverage.xml"

  if [[ -z "${SONAR_TOKEN}" ]]; then
    echo "No environment variable named SONAR_TOKEN. Cannot scan."
    exit 1
  elif [[ ! -f "${COMPILE_COMMANDS_FILE}" ]]; then
    echo "No compile_commands.json located in build dir ${BUILD_DIR}"
    exit 2
  elif [[ ! -f "${COVERAGE_FILE}" ]]; then
    echo "No coverage.xml located in coverage dir ${COVERAGE_DIR}"
    exit 2
  else
    sonar-scanner \
        --define sonar.host.url="${SONAR_SERVER_URL}" \
        --define sonar.cfamily.compile-commands="${COMPILE_COMMANDS_FILE}" \
        --define sonar.coverageReportPaths="${COVERAGE_FILE}"
  fi
}

case $BUILD_PHASE in 
  "BUILD" )
    _build;;
  "TEST" )
    _test;;
  "SCAN" )
    _scan;;
  * )
    echo >&2 "Invalid option $BUILD_PHASE"; exit 1;;
esac
