# ghostfolio-ansible-playbook
Ansible Playbook for setting up ghostfolio (on Unraid)

- using install.sh:
``` yaml
./install.sh
```

- using install.sh with custom ghostfolio save directory:
``` yaml
GHOSTFOLIO_DIR=/path/to/custom/dir ./install.sh
```

- simple ansible execution:
``` yaml
ansible-playbook ansible/playbooks/install-ghostfolio.yml
```

- with changing ghostfolio save directory:
``` yaml
GHOSTFOLIO_DIR=/path/to/custom/dir ansible-playbook -e "ghostfolio_dir=${GHOSTFOLIO_DIR}" ansible/playbooks/install-ghostfolio.yml
```