#!/bin/bash

GHOSTFOLIO_DIR=${GHOSTFOLIO_DIR:-/mnt/user/appdata/ghostfolio}
ANSIBLE_CUSTOM_IMAGE=ghostfolio-installer

runAnsible() {
  local command=$1
  # shellcheck disable=SC2086
  docker run --rm -it \
    -v "$(pwd)/ansible":/ansible \
    -v "${GHOSTFOLIO_DIR}":/ghostfolio \
    -v ~/.ssh/id_rsa:/root/id_rsa \
    -v /var/run/docker.sock:/var/run/docker.sock \
    "${ANSIBLE_CUSTOM_IMAGE}" ${command}
}

docker build -t "${ANSIBLE_CUSTOM_IMAGE}" --build-arg DOCKER_COMPOSE_VERSION=2.20.2 .
runAnsible "ansible-playbook -e ghostfolio_dir=/ghostfolio /ansible/playbooks/install-ghostfolio.yml"
echo "${GHOSTFOLIO_DIR}"
