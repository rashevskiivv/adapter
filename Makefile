ifeq ($(OS),Windows_NT)
CUR_DIR=$(shell echo %CD%)
else
CUR_DIR=$(shell pwd)
endif

IMAGE=nginx
TAG=latest
RELEASE_NAME=nginx
DC_FILE=-f ${CUR_DIR}/docker-compose.yaml

.PHONY: copy-env copy-env-windows deploy delete # compile

#compile: todo delete?
#	docker build --no-cache -f .docker/Dockerfile -t ${IMAGE}:${TAG} --target builder .

copy-env:
	cp .env.example .env

copy-env-windows:
	copy .env.example .env

deploy:
	cd deployment && docker-compose ${DC_FILE} -p ${RELEASE_NAME} up -d

delete:
	cd deployment && docker-compose ${DC_FILE} -p ${RELEASE_NAME} rm -sf
