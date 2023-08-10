FROM willhallonline/ansible:2.15-alpine-3.18

ARG DOCKER_COMPOSE_VERSION=2.20.2

# Install Docker Compose
RUN apk --no-cache add \
        curl && \
    curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
