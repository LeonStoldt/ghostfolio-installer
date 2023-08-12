FROM willhallonline/ansible:2.15-alpine-3.18


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
