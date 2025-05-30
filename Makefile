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

.PHONY: run prepare up compile copy-env copy-env-windows deploy delete

run:
	echo y|rmdir /s services
	mkdir services
	cd services && git clone git@github.com:KateMaliutina/recommendations.git
	cd services/recommendations && docker build --no-cache -f Dockerfile -t ${APP_RECOMMENDATIONS_IMAGE}:${TAG} .
	cd services/recommendations && docker build --no-cache -f PGDockerfile -t ${DB_RECOMMENDATIONS_IMAGE}:${TAG} .
	cd services && git clone git@github.com:rashevskiivv/api.git
	cd services/api/deployment && copy .env.example .env
	cd services/api && docker build --no-cache -f .docker/Dockerfile -t ${APP_API_IMAGE}:${TAG} --target builder .
	cd services/api && docker build --no-cache -f .docker/PGDockerfile -t ${DB_API_IMAGE}:${TAG} .
	cd services && git clone git@github.com:rashevskiivv/auth.git
	cd services/auth/deployment && copy .env.example .env
	cd services/auth && docker build --no-cache -f .docker/Dockerfile -t ${APP_AUTH_IMAGE}:${TAG} --target builder .
	cd services/auth && docker build --no-cache -f .docker/PGDockerfile -t ${DB_AUTH_IMAGE}:${TAG} .
	cd deployment && copy .env.example .env
	make compile
	make deploy

prepare:
	rm -rf services
	mkdir services
	cd services && git clone git@github.com:KateMaliutina/recommendations.git
	cd services/recommendations && docker build --no-cache -f Dockerfile -t ${APP_RECOMMENDATIONS_IMAGE}:${TAG} .
	cd services/recommendations && docker build --no-cache -f PGDockerfile -t ${DB_RECOMMENDATIONS_IMAGE}:${TAG} .
	cd services && git clone git@github.com:rashevskiivv/api.git
	cd services/api/deployment && cp .env.example .env
	cd services/api && docker build --no-cache -f .docker/Dockerfile -t ${APP_API_IMAGE}:${TAG} --target builder .
	cd services/api && docker build --no-cache -f .docker/PGDockerfile -t ${DB_API_IMAGE}:${TAG} .
	cd services && git clone git@github.com:rashevskiivv/auth.git
	cd services/auth/deployment && cp .env.example .env
	cd services/auth && docker build --no-cache -f .docker/PGDockerfile -t ${DB_AUTH_IMAGE}:${TAG} .
	cd deployment && cp .env.example .env
	make compile

up:
	cd services/auth && docker build --no-cache -f .docker/Dockerfile -t ${APP_AUTH_IMAGE}:${TAG} --target builder .
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
