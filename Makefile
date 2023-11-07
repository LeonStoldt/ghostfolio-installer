TEST_DIR=${PWD}/test
DEFAULT_POSTGRES_DB=ghostfolio-db
DEFAULT_POSTGRES_USER=ghostfolio

define wait_for_container
	@timeout=60; \
	while ! $1; do \
		sleep 5; \
		timeout=$$((timeout - 5)); \
		if [ $$timeout -le 0 ]; then \
			echo "Timed out waiting for container to start"; \
			exit 1; \
		fi; \
	done
endef

build:
	docker build -t ghostfolio-installer .

run: build
	 docker run --rm\
		-v ${TEST_DIR}:/ghostfolio \
	 	-v /var/run/docker.sock:/var/run/docker.sock \
	 	ghostfolio-installer

run-with-params: build
	docker run --rm \
		-e POSTGRES_PORT=5433 \
		-e REDIS_PW="OVERRIDE" \
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
	$(call wait_for_container, docker exec redis-ghostfolio redis-cli ping | grep PONG > /dev/null)
	@echo "wait for postgres to be healthy..."
	@wait-for-it localhost:5432 -t 60
	@echo "wait for ghostfolio to be healthy..."
	@wait-for-it localhost:3333 -t 60
