#!/bin/bash


docker::build_and_push() {
  common::envvars

  local image_name="${1}"
  local file_name="${2:-Dockerfile}"
  local bid="${BUILD_NUMBER}"
  local branch="${BUILD_BRANCH}"

  docker::build_file "${file_name}" "${image_name}" "${bid}" && \
  docker::push_and_tag "${image_name}" "${bid}" "${branch}" 
}

docker::build() {
  docker::build_file "Dockerfile" "$@"
}

docker::build_file() {
  common::envvars

  local file_name="$1"
  local image_name="$2"
  local bid="${3:-${BUILD_NUMBER}}"
  local branch="${BUILD_BRANCH}"
  local buildUrl="${BUILD_URL}" 
  local gitUrl="${BUILD_GIT_URL}"
  local buildTypeId="${BUILD_TYPE_ID}"
  local gitCommit="${BUILD_GIT_COMMIT}"

  if [ -n "$buildTypeId" ]; then
      cp ${file_name} ${file_name}_backup
      echo "" >> ${file_name}
      echo "LABEL com.tibco.mashling.ci.buildNumber=\"${bid}\" \\" >> ${file_name}
      echo " com.tibco.mashling.ci.buildTypeId=\"${buildTypeId}\" \\" >> ${file_name}
      echo " com.tibco.mashling.ci.url=\"${buildUrl}\"" >> ${file_name}
      if [ -n "${branch}" ]; then
          echo "LABEL com.tibco.mashling.git.repo=\"${gitUrl}\" com.tibco.mashling.git.commit=\"${gitCommit}\"" >> ${file_name}
      fi
  fi

  local latest='latest'
  if [[ -n ${branch} && ( ${branch} != 'master' ) ]]; then
    latest="latest-${branch}"
    bid="${bid}-${branch}"
  fi

  docker build --force-rm=true --rm=true -t $image_name:${bid:-latest} -f ${file_name} --build-arg GITHUB_USER_TOKEN=${GITHUB_USER_TOKEN} .
  docker tag $image_name:${bid:-latest} $image_name:latest
  rc=$?

  if [ -e "${file_name}_backup" ]; then
      rm ${file_name}
      mv ${file_name}_backup ${file_name}
  fi

  if [ $rc -ne 0 ]; then
    echo "Build failed"
    exit $rc
  fi
}

docker::pull_and_tag() {
  local base_name="$1"
  local docker_registry=$( [ -n "${DOCKER_REGISTRY}" ] && ensure_slash "${DOCKER_REGISTRY}" || echo "" ) 

  if [ -n "$docker_registry" ]; then
    docker pull ${docker_registry}${base_name} && \
    docker tag ${docker_registry}${base_name} ${base_name} && \
    docker rmi ${docker_registry}${base_name}
  fi
}

docker::push_and_tag() {
  common::envvars
  local image_name="$1"
  local bid="${2:-${BUILD_NUMBER}}"
  local docker_registry=$( [ -n "${DOCKER_REGISTRY}" ] && ensure_slash "${DOCKER_REGISTRY}" || echo "" ) 
  local branch="${BUILD_BRANCH}"
  local latest='latest'
  if [[ -n ${branch} && ( ${branch} != 'master' ) ]]; then
    latest="latest-${branch}"
    bid="${bid}-${branch}"
  fi

  if [[ -n ${branch} && ( ${branch} = 'master' ) ]]; then
    echo "Publishing image..."
    [ -n "${BUILD_RELEASE_TAG}" ] && docker::tag_and_release "${image_name}" "${bid}" "${BUILD_RELEASE_TAG}" "${branch}"
    # Do no push the "latest" tag to dockerhub if build cicd is travis and release tag is not specified
        if [[ "$(common::detect)" == "TRAVIS" ]]; then
            echo "BUILD_CICD=TRAVIS"
            docker tag  ${image_name}:${bid} ${docker_registry}${image_name}:${branch} && \
            docker push ${docker_registry}${image_name}:${branch} && \
            echo "Pushed ${docker_registry}${image_name}:${branch}" && \
            docker rmi ${docker_registry}${image_name}:${branch}
            if [[ -n "${BUILD_RELEASE_TAG}" ]]; then
              echo "BUILD_RELEASE_TAG=${BUILD_RELEASE_TAG}"
              docker tag  ${image_name}:${bid} ${image_name}:${latest} && \
              docker tag  ${image_name}:${bid} ${docker_registry}${image_name}:${latest} && \
              docker push ${docker_registry}${image_name}:${latest} && \
              echo "Pushed ${docker_registry}${image_name}:${latest}" && \
              docker rmi ${docker_registry}${image_name}:${latest}
            fi
        else
          # Handle local and teamcity builds here
          docker tag  ${image_name}:${bid} ${image_name}:${latest} && \
          docker tag  ${image_name}:${bid} ${docker_registry}${image_name}:${bid} && \
          docker tag  ${image_name}:${bid} ${docker_registry}${image_name}:${latest} && \
          docker push ${docker_registry}${image_name}:${latest} && \
          echo "Pushed ${docker_registry}${image_name}:${latest}" && \
          docker push ${docker_registry}${image_name}:${bid} && \
          echo "Pushed ${docker_registry}${image_name}:${bid}" && \
          docker rmi ${docker_registry}${image_name}:${latest} && \
          docker rmi ${docker_registry}${image_name}:${bid}
        fi
    echo "Published." 
  fi
}

docker::tag_and_release() {
  common::envvars
  local image_name="$1"
  local bid="${2:-${BUILD_NUMBER}}"
  local rtag="${3}"
  local docker_registry=$( [ -n "${DOCKER_REGISTRY}" ] && ensure_slash "${DOCKER_REGISTRY}" || echo "" ) 
  local branch="${4:-${BUILD_BRANCH}}"
  local latest='latest'
  if [[ -n ${branch} && ( ${branch} != 'master' ) ]]; then
    latest="latest-${branch}"
    bid="${bid}-${branch}"
  fi

  if [ -n "${bid}" -a -n "${rtag}" ]; then
    docker tag ${image_name}:${bid} ${image_name}:${rtag} && \
    docker tag ${image_name}:${bid} ${docker_registry}${image_name}:${rtag} && \
    docker images | grep ${image_name} >> ${BUILD_CACHE}/images.txt && \
    docker push ${docker_registry}${image_name}:${rtag} && \
    docker rmi ${docker_registry}${image_name}:${rtag} 
  fi
}


docker::copy_tag_and_push() {
  common::envvars
  local src_image_name="$1"
  local dest_image_name="$2"
  local bid="${3:-${BUILD_NUMBER}}"
  local docker_registry=$( [ -n "${DOCKER_REGISTRY}" ] && ensure_slash "${DOCKER_REGISTRY}" || echo "" ) 
  local branch="${BUILD_BRANCH}"
  local latest='latest'
  # non-branch-aware TeamCity jobs won't have $IS_MASTER at all
  if [[ -n ${branch} && ( ${branch} != 'master' ) ]]; then
    latest="latest-${branch}"
    bid="${bid}-${branch}"
  fi
  

  if [ -n "${bid}" -a -n "${branch}" ]; then
    echo "Retagging image from: ${src_image_name}:${bid} to: ${dest_image_name}:${bid} ..."
    docker tag ${src_image_name}:${bid} ${dest_image_name}:${latest} && \
    docker tag ${src_image_name}:${bid} ${docker_registry}${dest_image_name}:${bid} && \
    docker tag ${src_image_name}:${bid} ${docker_registry}${dest_image_name}:${latest} && \
    docker push ${docker_registry}${dest_image_name}:${latest} && \
    docker push ${docker_registry}${dest_image_name}:${bid} && \
    docker rmi ${docker_registry}${dest_image_name}:${latest} && \
    docker rmi ${docker_registry}${dest_image_name}:${bid} && \
    echo "Done."
  else
     # no bid and docker registry i.e. local machine
     docker tag  ${src_image_name}:${latest} ${dest_image_name}:${latest}
  fi
}


