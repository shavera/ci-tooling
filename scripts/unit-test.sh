#!/usr/bin/env bash

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "No directory specified by SOURCE_DIR exists. SOURCE_DIR=${SOURCE_DIR}"
  exit 1
fi

if [[ ! -d "${BUILD_DIR}" ]]; then
  echo "No directory specified by BUILD_DIR exists. BUILD_DIR=${BUILD_DIR}"
  exit 1
fi

if [[ ! -d "${COVERAGE_DIR}" ]]; then
  echo "No directory specified by COVERAGE_DIR exists. COVERAGE_DIR=${COVERAGE_DIR}"
  exit 1
fi

cd "$BUILD_DIR" || exit 1
ctest --no-tests=error

cd "$SOURCE_DIR" || exit 1
gcovr --sonarqube "${COVERAGE_DIR}/coverage.xml"
