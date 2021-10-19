#!/usr/bin/env bash

# This script assumes it's being run from where `sonar-scanner` should be called

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