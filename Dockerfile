FROM willhallonline/ansible:2.15-alpine-3.18

LABEL maintainer="tech@leon-stoldt.de" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="LeonStoldt/ghostfolio-installer" \
    org.label-schema.description="Ghostfolio installer using ansible inside Docker" \
    org.label-schema.url="https://github.com/LeonStoldt/ghostfolio-installer" \
    org.label-schema.vcs-url="https://github.com/LeonStoldt/ghostfolio-installer" \
    org.label-schema.vendor="Leon Stoldt" \
    org.label-schema.docker.cmd="docker run --rm -v $(pwd):/ghostfolio -v /var/run/docker.sock:/var/run/docker.sock ghostfolio-installer" \
    net.unraid.docker.icon="https://avatars.githubusercontent.com/u/82473144?s=200"

# Install Docker Compose
ARG DOCKER_COMPOSE_VERSION=2.20.2
RUN apk --no-cache add \
        curl && \
    curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

WORKDIR /ansible

COPY ansible /ansible

# ansible variabled which can be overridden
ENV GHOSTFOLIO_DIR=/ghostfolio
ENV POSTGRES_PORT=5432
ENV REDIS_PW=""
ENV POSTGRES_DB=ghostfolio-db
ENV POSTGRES_USER=ghostfolio
ENV POSTGRES_PW=postgresPw
ENV ACCESS_TOKEN_SALT=accessTokenSalt
ENV JWT_SECRET=jwtSecret

RUN mkdir $GHOSTFOLIO_DIR && chmod 775 /ghostfolio

CMD ansible-playbook /ansible/playbooks/install-ghostfolio.yml
