#---------------------------------------------------------------
# This makefile defines the following targets
#
# - all (default) - buid iroha-build container, and build iroha
# - docker        - build iroha runtime container
# - up            - running iroha container by docker-compose
# - down          - stop and remove iroha container by docker-compose
# - testup        - running iroha for test container by docker-compose
# - test          - exec all test commands
# - logs          - show logs of iroha_node_1 container
# - clean         - cleaning protobuf schemas and build directory
# - version       - show labels in container
#
# - iroha-dev     - build iroha-dev container
# - iroha-bld     - build iroha binaries
# - iroha-rel     - extract binaries, libraries from iroha build
# - iroha         - build iroha runtime container
#
# - iroha-up      - running iroha container by docker-compose
# - iroha-down    - stop and remove iroha container by docker-compose
#---------------------------------------------------------------
# Copyright 2017, 2018 Takeshi Yonezu All Rights Reserved.
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

.PHONY: all help docker up dwon testup test clean version

BUILD_HOME := $(shell pwd)/../iroha-ee
IROHA_HOME := /opt/iroha
IROHA_IMG := iroha-pi

GITLOG := $(shell scripts/$(IROHA_IMG)-gitlog.sh $(BUILD_HOME))

UKERNEL := $(shell uname -s)
UMACHINE := $(shell uname -m)

ifeq ($(UKERNEL),Linux)
  ifeq ($(UMACHINE),x86_64)
    PROJECT := hyperledger
    DOCKER := Dockerfile
    COMPOSE := docker-compose.yml
    COMPOSE_TEST := docker-compose-test.yml
  endif
  ifeq ($(UMACHINE),armv7l)
    PROJECT := arm32v7
    DOCKER := Dockerfile.arm32v7
    COMPOSE := docker-compose-arm32v7.yml
    COMPOSE_TEST := docker-compose-test-arm32v7.yml
  endif
  NUMCORE := $(shell grep processor /proc/cpuinfo | wc -l)
endif

ifeq ($(UKERNEL),Darwin)
  PROJECT := hyperledger
  DOCKER := Dockerfile
  COMPOSE := docker-compose.yml
  COMPOSE_TEST := docker-compose-test.yml
  NUMCORE := $(shell system_profiler SPHardwareDataType | grep Cores | sed 's/^.*Cores: //')
endif

ifeq ($(DOCKER), )
$(error This platform "$(UKERNEL)/$(UMACHINE)" in not supported.)
endif

all: $(IROHA_IMG)-dev $(IROHA_IMG)-bld $(IROHA_IMG)-rel $(IROHA_IMG)

help:
	@echo "help          - show make targets"
	@echo "all (default) - buid $(IROHA_IMG)-dev container, and build $(IROHA_IMG)"
	@echo "docker        - build $(IROHA_IMG) runtime container"
	@echo "up            - running $(IROHA_IMG) container by docker-compose"
	@echo "down          - stop and remove $(IROHA_IMG) container by docker-compose"
ifneq ($(UMACHINE),armv7l)
	@echo "testup        - running iroha for test container by docker-compose"
	@echo "test          - exec all test commands"
endif
	@echo "logs          - show logs of $(IROHA_IMG)_node_1 container"
	@echo "clean         - cleaning protobuf schemas and build directory"
	@echo "version       - show labels in container"

docker: $(IROHA_IMG)-rel $(IROHA_IMG)

up: $(IROHA_IMG)-up

down: $(IROHA_IMG)-down

ifneq ($(UMACHINE),armv7l)
testup: $(IROHA_IMG)-testup
endif

$(IROHA_IMG)-dev:
	cd docker/dev && docker build --rm --build-arg NUMCORE=$(NUMCORE) -t $(PROJECT)/$(IROHA_IMG)-dev -f $(DOCKER) .

$(IROHA_IMG)-bld:
	rsync -av scripts $(BUILD_HOME)
	docker run -t --rm --name $(IROHA_IMG)-bld -v $(BUILD_HOME):/opt/iroha $(PROJECT)/$(IROHA_IMG)-dev /opt/iroha/scripts/$(IROHA_IMG)-bld.sh $(NUMCORE)

$(IROHA_IMG)-rel:
	docker run -t --rm --name $(IROHA_IMG)-rel -v $(BUILD_HOME):/opt/iroha -w /opt/iroha $(PROJECT)/$(IROHA_IMG)-dev /opt/iroha/scripts/$(IROHA_IMG)-rel.sh
	rsync -av ${BUILD_HOME}/docker/iroha docker/rel
	rm -fr ${BUILD_HOME}/docker/iroha

$(IROHA_IMG):
	cd docker/rel; docker build --rm --build-arg GITLOG="$(GITLOG)" -t $(PROJECT)/$(IROHA_IMG) -f $(DOCKER) .

$(IROHA_IMG)-up:
	env COMPOSE_PROJECT_NAME=irohapi docker-compose -p irohapi -f $(COMPOSE) up -d

$(IROHA_IMG)-down:
	env COMPOSE_PROJECT_NAME=irohapi docker-compose -p irohapi -f $(COMPOSE) down

ifneq ($(UMACHINE),armv7l)
$(IROHA_IMG)-testup:
	env COMPOSE_PROJECT_NAME=irohapi docker-compose -p irohapi -f $(COMPOSE_TEST) up -d

test:
	cd scripts && bash $(IROHA_IMG)-test.sh
endif

logs:
	docker logs -f irohapi_node_1

clean:
	-rm -fr docker/rel/iroha
	-rm ${BUILD_HOME}/scripts/$(IROHA_IMG)*.sh
	-rm ${BUILD_HOME}/schema/*.{cc,h}
	rm -fr ${BUILD_HOME}/build

version:
	docker inspect -f {{.Config.Labels}} $(PROJECT)/$(IROHA_IMG)
