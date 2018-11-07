PACKAGE="hiracchi/gromacs"
TAG=latest
CONTAINER_NAME="pwff"
ARG=

.PHONY: build start stop restart term logs

build:
	docker build -t "${PACKAGE}:${TAG}" .


start:
	@\$(eval USER_ID := $(shell id -u))
	@\$(eval GROUP_ID := $(shell id -g))
	@echo "start docker as ${USER_ID}:${GROUP_ID}"
	docker run -t \
		--rm \
		--name ${CONTAINER_NAME} \
		-u $(USER_ID):$(GROUP_ID) \
		--volume "${PWD}:/work" \
		"${PACKAGE}:${TAG}" ${ARG}


start_as_root:
	@echo "start docker as root"
	docker run -t \
		--rm \
		--name ${CONTAINER_NAME} \
		--volume "${PWD}:/work" \
		"${PACKAGE}:${TAG}" ${ARG}


stop:
	docker rm -f ${CONTAINER_NAME}


restart: stop start


term:
	docker exec -it ${CONTAINER_NAME} /bin/bash


logs:
	docker logs ${CONTAINER_NAME}
