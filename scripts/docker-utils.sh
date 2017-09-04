#!/usr/bin/env bash

docker::getImageContainerName() {
    repo=${1%%/*}
    imagetag=${1##*/}
    image=${imagetag%%:*}
    tag=${imagetag##*:}
    echo "${image##*/}-container"
}

docker::getContainerId() {
    docker ps -a |grep "${1}" | awk '{ print $1; }'
}

docker::getImageIdByNameTag() {
    docker images |grep "${1}[[:space:]]*${2}" | awk '{ print $3; }'
}

docker::createContainer() {
    cont_name=$(docker::getImageContainerName "${1}")
    cont_id=$(docker::getContainerId ${cont_name}) 
    [ -n "${cont_id}" ] && docker rm -f ${cont_id} 2>&- >/dev/null
    docker create --name ${cont_name} ${1}
}

docker::removeContainer() {
    cont_name=$(docker::getImageContainerName "${1}") 
    cont_id=$(docker::getContainerId ${cont_name}) 
    [ -n "${cont_id}" ] && docker rm -f ${cont_id}
}