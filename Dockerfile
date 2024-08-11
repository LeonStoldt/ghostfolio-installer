ARG ANSIBLE_CORE_TAG
FROM willhallonline/ansible:${ANSIBLE_CORE_TAG:-alpine}

ARG VCS_REF
ARG BUILD_DATE
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
RUN apk --no-cache add \
        docker-compose

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

CMD ["ansible-playbook", "/ansible/playbooks/install-ghostfolio.yml"]
