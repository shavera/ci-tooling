#!/usr/bin/env bash

# USAGE: metabuild.sh [BUILD|TEST|SCAN]
# BUILD - build the project
# TEST - run unit tests, generate coverage report
# SCAN - run sonar scanner
# Note: script is not smart, it assumes these are run in the correct order

if [[ $# -ne 1 ]]; then 
  echo "Incorrect number of arguments passed."
  exit 1
fi

case $1 in 
  "BUILD" )
    return "$("${TOOLING_DIR}"/build-project.sh)";;
  "TEST" )
    return "$("${TOOLING_DIR}"/unit-test.sh)";;
  "SCAN" )
    return "$("${TOOLING_DIR}"/sonarscan.sh)";;
  * )
    echo >&2 "Invalid option $1"; exit 1;;
esac
