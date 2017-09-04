#!/usr/bin/env bash
unset SCRIPT_ROOT
readonly SCRIPT_ROOT=$(
  unset CDPATH
  script_root=$(dirname "${BASH_SOURCE}")
  cd "${script_root}/../.."
  pwd
)

source ${SCRIPT_ROOT}/scripts/init.sh

mashling::prebuild::mashling-contrib() {
    echo "#### Building mashling/mashling-contrib"
}

mashling::module::build "mashling-contrib"

