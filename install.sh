#!/bin/bash

set -x

GHOSTFOLIO_DIR=${GHOSTFOLIO_DIR:-/mnt/user/appdata/ghostfolio}

ANSIBLE_EXISTS=false
PYTHON_EXISTS=false
PIP_EXISTS=false

checkAnsible() {
  if command -v ansible &>/dev/null; then
    echo "Ansible already exists"
    ANSIBLE_EXISTS=true
  fi
}

installAnsible(){
    python3 -m pip install --user ansible
    ansible --version #verify
}

checkPython() {
  if command -v python3 &>/dev/null; then
    echo "python3 already exists"
    PYTHON_EXISTS=true
  fi
}

installPython() {
  echo "Install python3 via Unraid NerdTools (https://forums.unraid.net/topic/129200-plug-in-nerdtools/)"
  echo "APPS -> Search for 'NerdTools' and install"
  echo "SETTINGS -> NerdTools -> check python3 which will automatically check pip etc. and click 'Apply'"
  echo "restart the script when python3 and pip is available"
  exit 1
}

checkPip() {
  if command -v pip3 &>/dev/null; then
    echo "pip3 already exists"
    PIP_EXISTS=true
  fi
}

installPip() {
  echo "it is recommended to install python pip via nerdtools, if you still want to do it manually, execute the following lines of code and restart this script when pip is installed"
  echo "curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py"
  echo "python3 get-pip.py --user"
  exit 1
}

function checkAndInstallPrerequisites() {
  checkAnsible
  if [ "$ANSIBLE_EXISTS" = false ]; then
    checkPython
    if [ "$PYTHON_EXISTS" = false ]; then
      installPython
      checkPip
      if [ "$PIP_EXISTS" = false ]; then
        installPip
        fi
    fi
    installAnsible
  fi
}

checkAndInstallPrerequisites
ansible-playbook -e "ghostfolio_dir=${GHOSTFOLIO_DIR}" ansible/playbooks/install-ghostfolio.yml
