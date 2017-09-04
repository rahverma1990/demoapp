#!/bin/bash
component::build() {
  common::envvars

  local builder_image_name="${1}"
  local bid="${BUILD_NUMBER}"
  local docker_registry=$( [ -n "${DOCKER_REGISTRY}" ] && ensure_slash "${DOCKER_REGISTRY}" || echo "" )
  local default_args
  local extra_args="${EXTRA_ARGS}"
  local cmd="${CMD}"
  local branch="${BUILD_BRANCH}"
  #Master as latest
  local latest=${BUILD_RELEASE_TAG:-"master"}

  if [[ -n ${branch} && ( ${branch} != 'master' ) ]]; then
    latest="latest-$branch"
  fi


  if [ -z "${DEFAULT_ARGS}" ]; then
    default_args="-v `pwd`:/src"
  else
    default_args=${DEFAULT_ARGS}
  fi


  docker pull ${docker_registry}${builder_image_name}:${latest}
  if [ $? -ne 0 ]; then 
    # if the builder does not have a branch tagged image
    latest=${BUILD_RELEASE_TAG:-"master"}
    docker pull ${docker_registry}${builder_image_name}:${latest}
  fi
  docker tag ${docker_registry}${builder_image_name}:${latest} ${builder_image_name}:${latest}
  docker rmi ${docker_registry}${builder_image_name}:${latest}


  local container_name="builder-$bid"

  docker run --rm --name "${container_name}" ${default_args} ${extra_args} ${builder_image_name}:${latest} ${cmd}
  local result=$?
  docker rm -fv "${container_name}" &> /dev/null

  if [ ${result} -ne 0 ]; then
    echo "Build failed"
    exit 1
  fi
}

component::build_image() {
  component::build_image_file "Dockerfile" "$@"
}

component::build_image_file() {
  common::envvars
  local file_name=${1}
  local image_name=${2}
  local base_image=${3}
  local bid=${BUILD_NUMBER}
  local docker_registry=$( [ -n "${DOCKER_REGISTRY}" ] && ensure_slash "${DOCKER_REGISTRY}" || echo "" )
  local buildTypeId="${BUILD_TYPE_ID}"
  local branch="${BUILD_BRANCH}"
  local buildUrl="${BUILD_URL}" 
  local gitUrl="${BUILD_GIT_URL}"
  local gitCommit="${BUILD_GIT_COMMIT}"

  if [ -n "${docker_registry}" -a -n "${base_image}" ]; then
    docker pull ${docker_registry}${base_image}
    docker tag ${docker_registry}${base_image} ${base_image}
    docker rmi ${docker_registry}${base_image}
  fi

  if [ -n "$bid" ]; then
    cp ${file_name} ${file_name}_backup
    {
      echo ""
      echo "LABEL com.tibco.mashling.ci.buildNumber=\"${bid}\" \\" 
      echo " com.tibco.mashling.ci.buildTypeId=\"${buildTypeId}\" \\"
      echo " com.tibco.mashling.ci.url=\"${buildUrl}\""
      if [ -n "${branch}" ]; then
            echo "LABEL com.tibco.mashling.git.repo=\"${gitUrl}\" com.tibco.mashling.git.commit=\"${gitCommit}\""
      fi
    } >> ${file_name}
  fi
  local latest='latest'
  
  if [[ -n ${branch} && ( ${branch} != 'master' ) ]]; then
    latest="latest-$branch"
    bid="$bid-$branch"
  fi

  docker build --force-rm=true --rm=true -t "${image_name}:${bid:-latest}" -f ${file_name} .
  if [ $? -ne 0 ]; then
    echo "Build failed"
    exit 1
  fi

  if [ -e "${file_name}_backup" ]; then
      rm ${file_name}
      mv ${file_name}_backup ${file_name}
  fi
}

component::push_and_tag() {
    common::envvars
    local image_name=${1}
    local bid=${BUILD_NUMBER:-"0"}
    local docker_registry=$( [ -n "${DOCKER_REGISTRY}" ] && ensure_slash "${DOCKER_REGISTRY}" || echo "" )
    local buildTypeId="${BUILD_TYPE_ID}"
    local branch="${BUILD_BRANCH}"
    local buildUrl="${BUILD_URL}" 
    local gitUrl="${BUILD_GIT_URL}"
    local gitCommit="${BUILD_GIT_COMMIT}"
    local latest='latest'

      if [[ -n ${branch} && ( ${branch} != 'master' ) ]]; then
        latest="latest-$branch"
        bid="$bid-$branch"
      fi

      if [ -n "${bid}" -a -n "${DOCKER_REGISTRY+SET}" ]; then
        echo "Publishing image..."
        [ -n "${BUILD_RELEASE_TAG}" ] && docker::tag_and_release "${image_name}" "${bid}" "${BUILD_RELEASE_TAG}" "${branch}"
        # Do no push the "latest" tag to dockerhub if build cicd is travis and release tag is not specified
        if [[ "$(common::detect)" == "TRAVIS" ]]; then
            echo "BUILD_CICD=TRAVIS"
            docker tag  ${image_name}:${bid} ${docker_registry}${image_name}:${bid} && \
            docker push ${docker_registry}${image_name}:${bid} && \
            echo "Pushed ${docker_registry}${image_name}:${bid}" && \
            docker rmi ${docker_registry}${image_name}:${bid}
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