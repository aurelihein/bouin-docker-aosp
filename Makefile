DOCKER = docker
IMAGE = bouin-docker-aosp
VERSION = ubuntu_16.04-android_10

aosp: Dockerfile
	$(DOCKER) build -t $(IMAGE):$(VERSION) .

all: aosp

.PHONY: all
