# Ghostfolio-installer
> ### Ansible Playbook for Ghostfolio
> ![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
> [![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/leonstoldt/ghostfolio-installer)
> [![GitHub](https://img.shields.io/badge/ghcr.io-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/LeonStoldt/ghostfolio-installer/pkgs/container/ghostfolio-installer)
> 
> Ansible Playbook for setting up [ghostfolio](https://ghostfol.io/) (e.g. on ![Unraid](https://img.shields.io/badge/unraid-%23F15A2C.svg?style=for-the-badge&logo=unraid&logoColor=white))

## Prerequisites / Pre-Checks
As the docker image is based on `willhallonline/ansible`, check compatibility first.
Currently used docker base image version can be found in the [release workflow](.github/workflows/release.yml) and information about OS compatibility can be found [here](https://github.com/willhallonline/docker-ansible#compatibility).
If you need support for different/older OS, just create an issue or PR and we'll provide a new image.

## How to install / Getting started

### 1. Docker run (preferred)
Run ghostfolio-installer via docker (without env variables, it uses default values from [Dockerfile](./Dockerfile))
```shell
docker run --rm \
    -v /path/to/ghostfolio/dir:/ghostfolio \
    -v /var/run/docker.sock:/var/run/docker.sock \
    leonstoldt/ghostfolio-installer
```

It is **highly recommended** to adjust the variables and bootstrap ghostfolio with custom variables:
```shell
docker run --rm \
    -e REDIS_PW="R3DIS_s3cret!" \
    -e POSTGRES_PW=postgresPw \
    -e ACCESS_TOKEN_SALT=accessTokenSalt \
    -e JWT_SECRET=jwtSecret \
    -v /path/to/ghostfolio/dir:/ghostfolio \
    -v /var/run/docker.sock:/var/run/docker.sock \
    leonstoldt/ghostfolio-installer
```
More configuration options can be found below ([#Configuration](#configuration--docker-environment-variables)). 

### 2. Run ansible playbook manually
> Prerequisite: clone the repository first!

- call ansible playbook with variables:
``` yaml
GHOSTFOLIO_DIR=/path/to/ghostfolio/dir \
POSTGRES_PORT=5432 \
REDIS_PW="R3DIS_s3cret!" \
POSTGRES_DB=ghostfolio-db \
POSTGRES_USER=ghostfolio \
POSTGRES_PW=postgresPw \
ACCESS_TOKEN_SALT=accessTokenSalt \
JWT_SECRET=jwtSecret \
ansible-playbook /ansible/playbooks/install-ghostfolio.yml
```

## Configuration / Docker Environment Variables
> based on [ghostfolio - supported env variables ](https://github.com/ghostfolio/ghostfolio?tab=readme-ov-file#supported-environment-variables)

|   Env_Variable    | required to change? | recommended to change? | information                                                                         |
|:-----------------:|:-------------------:|:----------------------:|-------------------------------------------------------------------------------------|
|  GHOSTFOLIO_DIR   | :heavy_check_mark:  |   :heavy_check_mark:   | `/path/to/ghostfolio/dir` should point to your ghostfolio data persistence location |
|     REDIS_PW      |         :x:         |   :heavy_check_mark:   | you should provide a custom redis password for better security                      |
|    POSTGRES_PW    |         :x:         |   :heavy_check_mark:   | you should provide a custom postgres password for better security                   |
| ACCESS_TOKEN_SALT |         :x:         |   :heavy_check_mark:   | you should provide a custom, random access token salt for better security           |
|    JWT_SECRET     |         :x:         |   :heavy_check_mark:   | you should provide a custom, random jwt secret for better security                  |
|   POSTGRES_PORT   |         :x:         |          :x:           | only change port if you have conflicting ports or you know what you are doing       |
|    POSTGRES_DB    |         :x:         |          :x:           | only change the database name if you know what you are doing                        |
|   POSTGRES_USER   |         :x:         |          :x:           | only change the user if you know what you are doing                                 |

# Contributions
If you would like to improve this playbook, do not hesitate to create an issue or a pull request.
