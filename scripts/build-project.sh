#!/usr/bin/env bash

# Assumes that ci-slingshot will be mounted to a folder specified by an environment variable "SOURCE_DIR"
# Builds to a directory provided by environment variable "BUILD_DIR" - will generate this directory
# One or both of these directories may be mounted in a docker container

Help()
{
  # Display help
  echo "Syntax: build-project.sh [-b BUILD_DIR] SOURCE_DIR"
}
echo "START build script"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "No directory specified by SOURCE_DIR exists."
  exit 1
fi

if [[ ! -d "${BUILD_DIR}" ]]; then
  BUILD_DIR="${SOURCE_DIR}/build"
  echo "No valid build directory specified, creating it as ${BUILD_DIR}"
  mkdir -p BUILD_DIR
fi

cmake -G Ninja -DBUILD_CODE_COVERAGE=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -S "${SOURCE_DIR}" -B "${BUILD_DIR}"
cmake --build "${BUILD_DIR}" --target all
