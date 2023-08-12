TEST_DIR=${PWD}/test

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