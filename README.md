# Ghostfolio-installer
> ### Ansible Playbook for Ghostfolio
> ![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
> [![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/leonstoldt/ghostfolio-installer)
> [![GitHub](https://img.shields.io/badge/ghcr.io-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/LeonStoldt/ghostfolio-installer/pkgs/container/ghostfolio-installer)
> 
> Ansible Playbook for setting up [ghostfolio](https://ghostfol.io/) (e.g. on ![Unraid](https://img.shields.io/badge/unraid-%23F15A2C.svg?style=for-the-badge&logo=unraid&logoColor=white))

## Requirements
As the docker image is based on `willhallonline/ansible`, check compatibility first.
Currently used docker base image version can be found in the [release workflow](.github/workflows/release.yml) and information about OS compatibility can be found [here](https://github.com/willhallonline/docker-ansible#compatibility).
If you need support for different/older OS, just create an issue or PR and we'll provide a new image.

## Ways of installation

### 1. Docker run (preferred)
Run ghostfolio-installer via docker
```shell
docker run --rm \
    -v /path/to/ghostfolio/dir:/ghostfolio \
    -v /var/run/docker.sock:/var/run/docker.sock \
    leonstoldt/ghostfolio-installer
```

Run with custom variables:
```shell
docker run --rm \
    -e POSTGRES_PORT=5432 \
    -e REDIS_PW="" \
    -e POSTGRES_DB=ghostfolio-db \
    -e POSTGRES_USER=ghostfolio \
    -e POSTGRES_PW=postgresPw \
    -e ACCESS_TOKEN_SALT=accessTokenSalt \
    -e JWT_SECRET=jwtSecret \
    -v /path/to/ghostfolio/dir:/ghostfolio \
    -v /var/run/docker.sock:/var/run/docker.sock \
    leonstoldt/ghostfolio-installer
```

### 2. Run ansible playbook manually
> Prerequisite: clone the repository first!

- call ansible playbook with variables:
``` yaml
GHOSTFOLIO_DIR=/path/to/ghostfolio/dir \
POSTGRES_PORT=5432 \
REDIS_PW="" \
POSTGRES_DB=ghostfolio-db \
POSTGRES_USER=ghostfolio \
POSTGRES_PW=postgresPw \
ACCESS_TOKEN_SALT=accessTokenSalt \
JWT_SECRET=jwtSecret \
ansible-playbook /ansible/playbooks/install-ghostfolio.yml
```

# Contributions
If you would like to improve this playbook, do not hesitate to create an issue or a pull request.
