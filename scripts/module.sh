#!/usr/bin/env bash

mashling::module::prebuild() {
    fn_name="mashling::prebuild::${1}"
    if fn_exists ${fn_name} ; then
         ${fn_name} $@
    fi
}

mashling::module::postbuild() {
    fn_name="mashling::postbuild::${1}"
    if fn_exists ${fn_name} ; then
         ${fn_name} $@ 
    else 
        docker::push_and_tag mashling/${2}
    fi
}

mashling::module::onbuild() {
    fn_name="mashling::onbuild::${1}"
    if fn_exists ${fn_name} ; then
         ${fn_name} $@
    else
        docker::build mashling/${2}
    fi
}


mashling::module::build() {
    common::envvars
    # MASHLING_MODULE is the git repo name
    # MASHLING_IMAGE is the Docker image name build from MASHLING_MODULE artifacts and there can be more than one MASHLING_IMAGE from each MASHLING_MODULE
    local MASHLING_MODULE="${1}"
    local MASHLING_IMAGE="${2:-${MASHLING_MODULE}}"
    
    [ -z "${SCRIPT_ROOT}" ] && { echo "\${SCRIPT_ROOT} is not set" ; exit 1; }  
    [ -z "${MASHLING_MODULE}" ] && { echo "\${MASHLING_MODULE} is not set" ; exit 1; }  

    if [ "$(common::detect)" == "LOCAL" ]; then
        # Check if a git repo exists for the ${MASHLING_MODULE} only then performa a git clone
        git ls-remote https://github.com/TIBCOSoftware/${MASHLING_MODULE}.git > /dev/null 2>&1
        if [ $? -eq 0 ]; then

            rm -rf ${SCRIPT_ROOT}/submodules/${MASHLING_IMAGE}
            
            git clone https://github.com/TIBCOSoftware/${MASHLING_MODULE}.git \
                --branch ${BUILD_BRANCH} --single-branch \
                ${SCRIPT_ROOT}/submodules/${MASHLING_IMAGE}
            
        else
            # Create empty folders for copying the Dockerfiles
            mkdir -p ${SCRIPT_ROOT}/submodules/${MASHLING_IMAGE}
        fi
        
    elif [ "$(common::detect)" == "TRAVIS" ]; then
        # No need to do a separate git clone as Travis will do it and start the build
        # The following steps should be done in .travis.yml to tgzip the current git clone build files
        # Tar/Gzip the cloned artifacts from TRAVIS_BUILD_DIR
        # - tar cvfz ${MASHLING_MODULE}.tgz .
        # Remove all artifacts except the ${MASHLING_MODULE}.tgz
        # - find . -not -name "${MASHLING_MODULE}.tgz" -not  -name "\." -not -name "\.\."  -print0 | xargs -0 rm -rf --
        # - git clone https://github.com/TIBCOSoftware/mashling-cicd.git mashling-cicd
        mkdir -p  ${SCRIPT_ROOT}/submodules/${MASHLING_IMAGE}
        # In this inverted CICD architecture each module build is controlled from mashling-cicd
        # The build is done inside mashling-cicd/submodules/${MASHLING_IMAGE}/ folders where 
        # git cloned artifacts need to be present.
        pushd ${SCRIPT_ROOT}/submodules/${MASHLING_IMAGE}
            # Expand the ${MASHLING_MODULE}.tgz if one exists
            [ -r "${TRAVIS_BUILD_DIR}/${MASHLING_MODULE}.tgz" ] && \
                tar xvfz ${TRAVIS_BUILD_DIR}/${MASHLING_MODULE}.tgz
        popd
    fi
    

    # Build mashling/${MASHLING_MODULE} docker image
    pushd ${SCRIPT_ROOT}/submodules/${MASHLING_IMAGE}
        [ -r "${SCRIPT_ROOT}/docker/${MASHLING_IMAGE}/Dockerfile" ] && cp -fv ${SCRIPT_ROOT}/docker/${MASHLING_IMAGE}/Dockerfile .
        [ -r "${SCRIPT_ROOT}/docker/${MASHLING_IMAGE}/.dockerignore" ] && cp -fv ${SCRIPT_ROOT}/docker/${MASHLING_IMAGE}/.dockerignore .
        if [ "$(common::detect)" == "LOCAL" ]; then
            mashling::module::prebuild ${MASHLING_MODULE} ${MASHLING_IMAGE}
            mashling::module::onbuild ${MASHLING_MODULE} ${MASHLING_IMAGE} 
            mashling::module::postbuild ${MASHLING_MODULE} ${MASHLING_IMAGE}
        elif [ "$(common::detect)" == "TRAVIS" ]; then
            mashling::module::prebuild ${MASHLING_MODULE} ${MASHLING_IMAGE}
            mashling::module::onbuild ${MASHLING_MODULE} ${MASHLING_IMAGE} 
        fi
    popd
}

command_exists() {
       	command -v "$@" > /dev/null 2>&1
}

mashling::module::getLastSuccesfulBuildNumber() {
    if ! command_exists jq ; then  return 1; fi
    if ! command_exists curl ; then  return 1; fi
    [ -n "${TRAVIS_API_TOKEN}" ] || { echo "TRAVIS_API_TOKEN is missing"; return 1; }
    travis_token=${1:-"${TRAVIS_API_TOKEN}"}
    travis_repo_slug=${2:-"${TRAVIS_REPO_SLUG}"}
    travis_uri="https://api.travis-ci.${3:-"com"}/repos/${repo_slug}/builds"

    read -r build_id build_status build_number <<< $(curl -sS -H "Accept: application/vnd.travis-ci.2+json"  \
            -H "Authorization: Token ${travis_token}"  \
            "${travis_uri}" | \
            sed -e 's/=>/:/g' -e 's/nil/\"nil\"/g' | \
            jq -r '[.builds[]|select(.state =="passed")| {"id":.id,"state":.state,"number":.number}]|max_by(.id)|(.id|tostring)+"  "+.state+"  "+.number' )
    # echo ${build_id}
    # echo ${build_status}
    echo ${build_number}
}

mashling::module::generateDockerComposeStartup(){
    MASHLING_WEB_TAG=${1:-"latest"}
    FLOW_SERVICE_TAG=${2:-"latest"}
    STATE_SERVICE_TAG=${3:-"latest"}
    {
        echo "#!/bin/bash"
        echo "script_root=\$(dirname \"\${BASH_SOURCE}\")"
        [ -n "${BUILD_RELEASE_TAG:-latest}" ] && echo "export MASHLING_WEB_TAG=${MASHLING_WEB_TAG:-latest}"
        [ -n "${BUILD_RELEASE_TAG:-latest}" ] && echo "export FLOW_SERVICE_TAG=${FLOW_SERVICE_TAG:-latest}"
        [ -n "${BUILD_RELEASE_TAG:-latest}" ] && echo "export STATE_SERVICE_TAG=${STATE_SERVICE_TAG:-latest}"
        [ -n "${DOCKER_REGISTRY}" ] && echo "export DOCKER_REGISTRY=${DOCKER_REGISTRY}"
        echo "docker-compose -f \${script_root}/docker-compose.yml up"
        echo "docker-compose rm -f"
    } > docker-compose-start.sh 
    chmod +x docker-compose-start.sh
}
mashling::module::generateStartup() {
    if [ "$(common::detect)" == "LOCAL" ]; then
        local bid="${BUILD_NUMBER}"
        local rtag="${BUILD_RELEASE_TAG}"
        local branch="${BUILD_BRANCH}"
        local latest='latest'
        if [[ -n ${branch} && ( ${branch} != 'master' ) ]]; then
            latest="latest-${branch}"
            bid="${bid}-${branch}"
        fi
        mashling::module::generateDockerComposeStartup "${rtag:-${latest}}" "${rtag:-${latest}}" "${rtag:-${latest}}"
    elif [ "$(common::detect)" == "TRAVIS" ]; then
        # When doing a tagged build, use the same tag for all docker images
        if [ -n "${BUILD_RELEASE_TAG}" ]; then
            mashling::module::generateDockerComposeStartup "${BUILD_RELEASE_TAG:-latest}" "${BUILD_RELEASE_TAG:-latest}" "${BUILD_RELEASE_TAG:-latest}"
        else
            MASHLING_WEB_TAG=$(mashling::module::getLastSuccesfulBuildNumber ${TRAVIS_API_TOKEN} TIBCOSoftware/mashling-web ${TRAVIS_TYPE})
            MASHLING_SERVICES_TAG=$(mashling::module::getLastSuccesfulBuildNumber ${TRAVIS_API_TOKEN} TIBCOSoftware/mashling-services ${TRAVIS_TYPE})
            mashling::module::generateDockerComposeStartup "${MASHLING_WEB_TAG:-latest}" "${MASHLING_SERVICES_TAG:-latest}" "${MASHLING_SERVICES_TAG:-latest}"
        fi
    fi
}