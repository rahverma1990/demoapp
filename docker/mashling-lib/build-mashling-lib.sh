#!/usr/bin/env bash
unset SCRIPT_ROOT
readonly SCRIPT_ROOT=$(
  unset CDPATH
  script_root=$(dirname "${BASH_SOURCE}")
  cd "${script_root}/../.."
  pwd
)

source ${SCRIPT_ROOT}/scripts/init.sh

mashling::prebuild::mashling-lib() {
    echo "#### Building mashling/mashling-lib"
}

mashling::module::build "mashling-lib"

