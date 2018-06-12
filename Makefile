APP_NAME=prerender
VERSION?=stage
IMAGE_NAME=$(APP_NAME):${VERSION}

run:
	docker run -p 3000:80 ${GCR_URL}/${IMAGE_NAME}

build:
	docker build -t="faceit/${IMAGE_NAME}" .


tag-latest:
	docker tag faceit/${IMAGE_NAME} faceit/${APP_NAME}:latest

push-latest:
	docker push faceit/${APP_NAME}:latest

push:
	docker push faceit/${IMAGE_NAME}

all: build push

all-latest: all tag-latest push-latest

