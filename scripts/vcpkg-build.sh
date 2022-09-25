#!/bin/bash
#
# Copyright (c) 2021 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

export LC_ALL=C

NUMCORE=$(./scripts/numcore.sh)

BUILD_HOME=${PWD}/../iroha
IROHA_VCPKG=${BUILD_HOME}/vcpkg
VCPKG_PATH=${IROHA_VCPKG}/vcpkg
IROHA_HOME=/opt/iroha

case $(uname -s) in
  Linux)   SYS=linux;;
  Darwin)  SYS=osx;;
  *) echo "\"$(uname -s)\" system does'nt support."; exit 1;;
esac

case $(uname -m) in
  x86_64)  ARC=x64;;
  armv7l)  ARC=arm;;
  aarch64) ARC=arm64;;
  *) echo "\"$(uname -m)\" architecture does'nt support."; exit 1;;
esac 

sudo apt install -y automake build-essential ca-certificates ccache \
  cmake git libssl-dev rsync zlib1g-dev libcurl4-openssl-dev python3 curl \
  ninja-build zip unzip

## # cmake 3.14.0
## echo ">>> Build cmake 3.14.0"
## if ! which cmake >/dev/null; then
##   git clone https://gitlab.kitware.com/cmake/cmake.git /tmp/cmake
##   cd /tmp/cmake
## ##git checkout bf02d625325535f485512eba307cff54c08bb257
##   git checkout e8dbfcf6797a270ed5be8550248f7fe4fe5dec79
##   ./bootstrap --system-curl --parallel=${NUMCORE} --enable-ccache
##   make -j${NUMCORE}
##   sudo make install
##   cd
##   rm -fr /tmp/cmake
## fi

echo ">>> Build vcpkg"
if [ ! -d ${VCPKG_PATH} ]; then
  cd ${IROHA_VCPKG}
  git clone https://github.com/microsoft/vcpkg.git

  cd vcpkg
# git checkout $(cat ${IROHA_VCPKG}/VCPKG_COMMIT_SHA)
  git checkout 2020.11-1

  for i in ${IROHA_VCPKG}/patches/0001-*.patch; do
    git -C ${VCPKG_PATH} apply --ignore-whitespace $i
  done

  if [[ "${ARC}" = "arm" || "${ARC}" = "arm64" ]]; then
    cat <<EOF >${IROHA_VCPKG}/patches/0000-tbb-arm.patch
diff -c a/ports/tbb/CONTROL b/ports/tbb/CONTROL
*** a/ports/tbb/CONTROL	Wed Jan 13 19:01:14 2021
--- b/ports/tbb/CONTROL	Wed Jan 13 19:04:45 2021
***************
*** 2,5 ****
  Version: 2020_U3
  Homepage: https://github.com/01org/tbb
  Description: Intel's Threading Building Blocks.
! Supports: !(uwp|arm|arm64)
\ No newline at end of file
--- 2,5 ----
  Version: 2020_U3
  Homepage: https://github.com/01org/tbb
  Description: Intel's Threading Building Blocks.
! Supports: !(uwp)
diff -c a/ports/tbb/portfile.cmake b/ports/tbb/portfile.cmake
*** a/ports/tbb/portfile.cmake	Wed Jan 13 19:01:14 2021
--- b/ports/tbb/portfile.cmake	Wed Jan 13 19:04:48 2021
***************
*** 1,5 ****
- vcpkg_fail_port_install(ON_ARCH "arm" "arm64" ON_TARGET "uwp")
- 
  vcpkg_from_github(
      OUT_SOURCE_PATH SOURCE_PATH
      REPO oneapi-src/oneTBB
--- 1,3 ----
EOF

    patch -p1 <${IROHA_VCPKG}/patches/0000-tbb-arm.patch 
  fi

  ${VCPKG_PATH}/bootstrap-vcpkg.sh -disableMetrics -useSystemBinaries

  export VCPKG_DISABLE_METRICS=1
  export VCPKG_FORCE_SYSTEM_BINARIES=1

  cat ${IROHA_VCPKG}/VCPKG_DEPS_LIST      | xargs ${VCPKG_PATH}/vcpkg install
# cat ${IROHA_VCPKG}/VCPKG_HEAD_DEPS_LIST | xargs ${VCPKG_PATH}/vcpkg install --head
fi

echo ">>> Build protoc-gen-go"
if [ ! -x ${HOME}/go/bin/protoc-gen-go ]; then
  cd ${HOME}
  mkdir -p go/src
  cd go/src
  go get -u google.golang.org/protobuf/cmd/protoc-gen-go
  go install google.golang.org/protobuf/cmd/protoc-gen-go

  export PATH="${HOME}/go/bin:/usr/local/go/bin:$PATH"
fi

protoc-gen-go --version

echo ">>> Build Cmakefiles"
if [ ! -d ${BUILD_HOME}/build ]; then
  mkdir ${BUILD_HOME}/build
fi

cd ${BUILD_HOME}/build

cmake -B. -S.. \
  -DCMAKE_BUILD_TYPE=Release \
  -DTESTING=OFF \
  -DUSE_LIBURSA=OFF \
  -DUSE_BURROW=OFF \
  -DCMAKE_TOOLCHAIN_FILE=${VCPKG_PATH}/scripts/buildsystems/vcpkg.cmake

echo ">>> Build Iroha"
cmake --build . -- -j${NUMCORE}

exit 0
