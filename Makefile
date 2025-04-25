ifeq ($(OS),Windows_NT)
CUR_DIR=$(shell echo %CD%)
else
CUR_DIR=$(shell pwd)
endif

IMAGE=nginx_local
TAG=latest
APP_API_IMAGE=api_local
DB_API_IMAGE=api-db
APP_RECOMMENDATIONS_IMAGE=recommendations_local
DB_RECOMMENDATIONS_IMAGE=recommendations-db
APP_AUTH_IMAGE=auth_local
DB_AUTH_IMAGE=auth-db
RELEASE_NAME=procareer
DC_FILE=-f ${CUR_DIR}/deployment/docker-compose.yaml

.PHONY: run compile copy-env copy-env-windows deploy delete

run:
	cd services/recommendations && docker build --no-cache -f Dockerfile -t ${APP_RECOMMENDATIONS_IMAGE}:${TAG} .
	make deploy

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
