TEST_DIR=${PWD}/test
DEFAULT_POSTGRES_DB=ghostfolio-db
DEFAULT_POSTGRES_USER=ghostfolio

define wait_for_container
	@timeout=60; \
	while [ $$(docker inspect --format "{{json .State.Health.Status }}" $1) != '"healthy"' ]; do \
		sleep 5; \
		timeout=$$((timeout - 5)); \
		if [ $$timeout -le 0 ]; then \
			echo "Timed out waiting for container to start"; \
			exit 1; \
		fi; \
	done
endef

define docker-build
	docker buildx build --pull \
		--build-arg ANSIBLE_CORE_TAG=$(1) \
		--build-arg BUILD_DATE="$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')" \
		--build-arg VCS_REF="$(shell git rev-parse --short HEAD)" \
		--platform $(2) \
		-t ghostfolio-installer .
endef

build:
	$(call docker-build,"2.18-alpine-3.22","linux/amd64") # renovate: datasource=docker depName=willhallonline/ansible versioning=docker

build-arm:
	$(call docker-build,"alpine","linux/arm64")

run: build
	 docker run --rm\
		-v ${TEST_DIR}:/ghostfolio \
	 	-v /var/run/docker.sock:/var/run/docker.sock \
	 	ghostfolio-installer

run-with-params: build
	docker run --rm \
		-e POSTGRES_PORT=5433 \
		-e REDIS_PW="redis_password" \
		-e POSTGRES_DB=my-db \
		-e POSTGRES_USER=myuser \
		-e POSTGRES_PW=mypwforghostfolio \
		-e ACCESS_TOKEN_SALT=accessTokenSaltOverride \
		-e JWT_SECRET=jwtOverride \
		-v ${TEST_DIR}:/ghostfolio \
		-v /var/run/docker.sock:/var/run/docker.sock \
		ghostfolio-installer

test: run
	@echo "wait for redis to be healthy..."
	$(call wait_for_container, redis-ghostfolio)
	@echo "wait for postgres to be healthy..."
	$(call wait_for_container, postgresql16-ghostfolio)
	@echo "wait for ghostfolio to be healthy..."
	$(call wait_for_container, ghostfolio)

cleanup-test:
	docker compose -f ${TEST_DIR}/docker-compose.yml down -v

update-ghostfolio-sha:
	curl -s https://raw.githubusercontent.com/ghostfolio/ghostfolio/main/docker/docker-compose.yml | sha1sum > ./.ghostfolio/.docker-compose.sha

update-ansible-image-digest:
	docker manifest inspect willhallonline/ansible:2.18-alpine-3.22 | jq -r 'if .manifests then .manifests[] | select(.platform.architecture == "amd64").digest else .config.digest end' > .github/ansible-docker-digests/amd64.sha