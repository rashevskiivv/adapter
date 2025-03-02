ifeq ($(OS),Windows_NT)
CUR_DIR=$(shell echo %CD%)
else
CUR_DIR=$(shell pwd)
endif

IMAGE=nginx_local
TAG=latest
RELEASE_NAME=nginx
DC_FILE=-f ${CUR_DIR}/deployment/docker-compose.yaml

.PHONY: compile copy-env copy-env-windows deploy delete

compile:
	docker build --no-cache -f .docker/Dockerfile -t ${IMAGE}:${TAG} .

copy-env:
	cp .env.example .env

copy-env-windows:
	copy .env.example .env

deploy:
	docker-compose ${DC_FILE} -p ${RELEASE_NAME} up -d

delete:
	docker-compose ${DC_FILE} -p ${RELEASE_NAME} rm -sf
