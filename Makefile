CUR_DIR                := $(shell pwd)
PROJECT_NAME           := $(shell basename ${CUR_DIR})
GIT_BRANCH             := $(shell git symbolic-ref --short HEAD)
GIT_SHORT_SHA          := $(shell git rev-parse --short ${GIT_BRANCH})
DOCKER_IMAGE_NAME      := johnae/haproxy-dev
DOCKER_BRANCH          := $(shell echo -n ${GIT_BRANCH} | sed 's/\//_/g' | sed 's/[!?\#]//g')
# just using latest here
#DOCKER_TAG             := ${DOCKER_BRANCH}-${GIT_SHORT_SHA}
#DOCKER_FULL_IMAGE_NAME := ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
DOCKER_FULL_IMAGE_NAME := ${DOCKER_IMAGE_NAME}

.PHONY: clean

all: build

print-%:
	@echo $*=$($*)

build:
	docker build --force-rm -t ${DOCKER_FULL_IMAGE_NAME} .

push:
	docker push ${DOCKER_IMAGE_NAME}:latest

build-and-push: build push

clean-old-images:
	$(eval LATEST_SHA := $(shell docker images | tail -n +2 | grep "${DOCKER_IMAGE_NAME}" | grep "latest" | awk '{print $$3}'))
	@ docker images | \
		tail -n +2 | \
		grep "${DOCKER_IMAGE_NAME}" | \
		awk '{print $$3}' | \
		grep -v "${LATEST_SHA}" | \
		xargs -r docker rmi 2>/dev/null || true
