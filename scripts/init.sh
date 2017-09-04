#!/bin/bash

readonly INIT_ROOT=$(
  unset CDPATH
  init_root=$(dirname "${BASH_SOURCE}")/..
  cd "${init_root}"
  pwd
)

source "${INIT_ROOT}/scripts/common.sh"
source "${INIT_ROOT}/scripts/docker-build.sh"
source "${INIT_ROOT}/scripts/component.sh"
source "${INIT_ROOT}/scripts/module.sh"
source "${INIT_ROOT}/scripts/docker-utils.sh"
