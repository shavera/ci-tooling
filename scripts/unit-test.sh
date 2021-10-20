#!/usr/bin/env bash

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
