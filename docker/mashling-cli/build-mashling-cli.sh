#!/usr/bin/env bash
unset SCRIPT_ROOT
readonly SCRIPT_ROOT=$(
  unset CDPATH
  script_root=$(dirname "${BASH_SOURCE}")
  cd "${script_root}/../.."
  pwd
)
source ${SCRIPT_ROOT}/scripts/init.sh

mashling::prebuild::mashling-cli() {
    echo "#### Building mashling/mashling-cli"
    docker::pull_and_tag mashling/mashling-base:${BUILD_RELEASE_TAG:-"latest"}
}

mashling::module::build "mashling-cli"