#---------------------------------------------------------------
# This makefile defines the following targets
#
# - all (default) - buid iroha-pi-build container, and build iroha-pi
# - docker        - build iroha-pi runtime container
# - up            - running iroha-pi container by docker-compose
# - down          - stop and remove iroha-pi container by docker-compose
# - test          - exec all test commands
# - logs          - show logs of iroha-pi_node_1 container
# - clean         - cleaning protobuf schemas and build directory
#
# - iroha-pi-dev  - build iroha-pi-dev container
# - iroha-pi-bld  - build iroha-pi binaries
# - iroha-pi-rel  - extract binaries, libraries from iroha-pi build
# - iroha-pi      - build iroha-pi runtime container
#
# - iroha-pi-up   - running iroha-pi container by docker-compose
# - iroha-pi-down - stop and remove iroha-pi container by docker-compose
#---------------------------------------------------------------
# Copyright 2017 Takeshi Yonezu All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.PHONY: all help docker up dwon test clean

IROHA_HOME := /opt/iroha
BUILD_HOME := $(shell pwd)/../iroha-ee

GITLOG := $(shell scripts/iroha-pi-gitlog.sh $(BUILD_HOME))

UKERNEL := $(shell uname -s)
UMACHINE := $(shell uname -m)

ifeq ($(UKERNEL),Linux)
  ifeq ($(UMACHINE),x86_64)
    PROJECT := hyperledger
    DOCKER := Dockerfile
    COMPOSE := docker-compose.yml
  endif
  ifeq ($(UMACHINE),armv7l)
    PROJECT := arm32v7
    DOCKER := Dockerfile.arm32v7
    COMPOSE := docker-compose-arm32v7.yml
  endif
  NUMCORE := $(shell grep processor /proc/cpuinfo | wc -l)
endif

ifeq ($(UKERNEL),Darwin)
  PROJECT := hyperledger
  DOCKER := Dockerfile
  COMPOSE := docker-compose.yml
  NUMCORE := $(shell system_profiler SPHardwareDatraType | grep Cores | grep 's/^.*Cores: //')
endif

ifeq ($(DOCKER), )
$(error This platform "$(UKERNEL)/$(UMACHINE)" in not supported.)
endif

all: iroha-pi-dev iroha-pi-bld iroha-pi-rel iroha-pi

help:
	@echo "help          - show make targets"
	@echo "all (default) - buid iroha-pi-dev container, and build iroha-pi"
	@echo "docker        - build iroha-pi runtime container"
	@echo "up            - running iroha-pi container by docker-compose"
	@echo "down          - stop and remove iroha-pi container by docker-compose"
	@echo "test          - exec all test commands"
	@echo "logs          - show logs of iroha-pi_node_1 container"
	@echo "clean         - cleaning protobuf schemas and build directory"

docker: iroha-pi-rel iroha-pi

up: iroha-pi-up

down: iroha-pi-down

iroha-pi-dev:
	cd docker/dev && docker build --rm --build-arg NUMCORE=$(NUMCORE) -t $(PROJECT)/iroha-pi-dev -f $(DOCKER) .

iroha-pi-bld:
	rsync -av scripts $(BUILD_HOME)
	docker run -t --rm --name iroha-pi-bld -v $(BUILD_HOME):/opt/iroha hyperledger/iroha-pi-dev /opt/iroha/scripts/iroha-pi-bld.sh $(NUMCORE)

iroha-pi-rel:
	docker run -t --rm --name iroha-pi-rel -v $(BUILD_HOME):/opt/iroha -w /opt/iroha $(PROJECT)/iroha-pi-dev /opt/iroha/scripts/iroha-pi-rel.sh
	rsync -av ${BUILD_HOME}/docker/iroha docker/rel
	rm -fr ${BUILD_HOME}/docker/iroha

iroha-pi:
	cd docker/rel; docker build --rm --build-arg GITLOG="$(GITLOG)" -t $(PROJECT)/iroha-pi -f $(DOCKER) .

iroha-pi-up:
	cd docker && env COMPOSE_PROJECT_NAME=irohapi docker-compose -p irohapi -f $(COMPOSE) up -d

iroha-pi-down:
	cd docker && env COMPOSE_PROJECT_NAME=irohapi docker-compose -p irohapi -f $(COMPOSE) down

test:
	cd scripts && bash iroha-pi-test.sh

logs:
	docker logs -f irohapi_node_1

clean:
	-rm -fr docker/rel/iroha
	-rm ${BUILD_HOME}/scripts/iroha-pi*.sh
	-rm ${BUILD_HOME}/schema/*.{cc,h}
	rm -fr ${BUILD_HOME}/build
