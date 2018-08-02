# Copyright Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

FROM ubuntu:16.04

ARG NUMCORE=${NUMCORE:-4}
ARG CMAKE_BUILD_TYPE=Release

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y --no-install-recommends install \
    automake build-essential ca-certificates ccache \
    git libssl-dev rsync zlib1g-dev libcurl4-openssl-dev \
    python3 python-software-properties curl \
 && apt-get -y clean

# install cmake 3.10.2
RUN git clone https://gitlab.kitware.com/cmake/cmake.git /tmp/cmake \
 && (cd /tmp/cmake; git checkout c1e087a9d3af74299d7681c9f9de59e5977a1539) \
 && (cd /tmp/cmake; /tmp/cmake/bootstrap --system-curl --parallel=${NUMCORE} --enable-ccache) \
 && make -j${NUMCORE} -C /tmp/cmake \
 && make -C /tmp/cmake install \
 && ldconfig \
 && rm -fr /tmp/cmake

# install boost 1.65.1
RUN git clone https://github.com/boostorg/boost /tmp/boost \
 && (cd /tmp/boost; git checkout 436ad1dfcfc7e0246141beddd11c8a4e9c10b146) \
 && (cd /tmp/boost; git submodule update --init --recursive) \
 && (cd /tmp/boost; /tmp/boost/bootstrap.sh --with-libraries=system,filesystem) \
 && (cd /tmp/boost; /tmp/boost/b2 headers) \
 && (cd /tmp/boost; /tmp/boost/b2 cxxflags="-std=c++14" -j${NUMCORE} install) \
 && ldconfig \
 && rm -fr /tmp/boost

# install protobuf v3.5.1
RUN git clone https://github.com/google/protobuf /tmp/protobuf \
 && (cd /tmp/protobuf; git checkout 106ffc04be1abf3ff3399f54ccf149815b287dd9) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -Dprotobuf_BUILD_TESTS=OFF \
      -Dprotobuf_BUILD_SHARED_LIBS=ON \
      -H/tmp/protobuf/cmake \
      -B/tmp/protobuf/.build \
 && cmake --build /tmp/protobuf/.build --target install -- -j${NUMCORE} \
 && ldconfig \
 && rm -fr /tmp/protobuf

# install gflags
RUN git clone https://github.com/gflags/gflags /tmp/gflags \
 && (cd /tmp/gflags; git checkout f8a0efe03aa69b3336d8e228b37d4ccb17324b88) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -H/tmp/gflags \
      -B/tmp/gflags/build \
 && cmake --build /tmp/gflags/build --target install -- -j${NUMCORE} \
 && ldconfig \
 && rm -rf /tmp/gflags

# install c-ares
RUN git clone https://github.com/c-ares/c-ares /tmp/c-ares \
 && (cd /tmp/c-ares; git checkout 3be1924221e1326df520f8498d704a5c4c8d0cce) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -H/tmp/c-ares \
      -B/tmp/c-ares/build \
 && cmake --build /tmp/c-ares/build --target install -- -j${NUMCORE} \
 && ldconfig \
 && rm -rf /tmp/c-ares

# install grpc 1.11.0
RUN git clone https://github.com/grpc/grpc /tmp/grpc \
 && (cd /tmp/grpc; git checkout bd44e485f69d70ca4095cea92decd98de3892aa6) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DgRPC_BENCHMARK_PROVIDER="" \
      -DgRPC_ZLIB_PROVIDER=package \
      -DgRPC_CARES_PROVIDER=package \
      -DgRPC_SSL_PROVIDER=package \
      -DgRPC_PROTOBUF_PROVIDER=package \
      -DgRPC_GFLAGS_PROVIDER=package \
      -DBUILD_SHARED_LIBS=ON \
      -H/tmp/grpc \
      -B/tmp/grpc/.build \
 && cmake --build /tmp/grpc/.build --target install -- -j${NUMCORE} \
 && ldconfig \
 && rm -rf /tmp/grpc

# install gtest
RUN git clone https://github.com/google/googletest /tmp/googletest \
 && (cd /tmp/googletest; git checkout ec44c6c1675c25b9827aacd08c02433cccde7780) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -H/tmp/googletest \
      -B/tmp/googletest/build \
 && cmake --build /tmp/googletest/build --target install -- -j${NUMCORE} \
 && ldconfig \
 && rm -rf /tmp/googletest

# install spdlog v0.16.3
RUN git clone https://github.com/gabime/spdlog /tmp/spdlog \
 && (cd /tmp/spdlog; git checkout ccd675a286f457068ee8c823f8207f13c2325b26) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DSPDLOG_BUILD_TESTING=OFF \
      -H/tmp/spdlog \
      -B/tmp/spdlog/build \
 && cmake --build /tmp/spdlog/build --target install \
 && rm -rf /tmp/spdlog

# install rxcpp
RUN git clone https://github.com/Reactive-Extensions/RxCpp /tmp/RxCpp \
 && (cd /tmp/RxCpp; git checkout 1b2e0589f19cb34d8cd58803677701dcf2161876) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -H/tmp/RxCpp \
      -B/tmp/RxCpp/build \
 && cmake --build /tmp/RxCpp/build --target install \
 && rm -fr /tmp/RxCpp

# install rapidjson
RUN git clone https://github.com/miloyip/rapidjson /tmp/rapidjson \
 && (cd /tmp/rapidjson; git checkout f54b0e47a08782a6131cc3d60f94d038fa6e0a51) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DRAPIDJSON_BUILD_EXAMPLES=OFF \
      -H/tmp/rapidjson \
      -B/tmp/rapidjson/build \
 && cmake --build /tmp/rapidjson/build --target install \
 && ldconfig \
 && rm -fr /tmp/rapidjson

# install libpq
RUN git clone https://git.postgresql.org/git/postgresql.git /tmp/postgresql \
 && cd /tmp/postgresql \
 && git checkout 029386ccbddd0a33d481b94e511f5219b03e6636 \
 && ./configure --without-readline --prefix=/usr/local \
 && make -j${NUMCORE} -C src/bin/pg_config \
 && make -j${NUMCORE} -C src/interfaces/libpq \
 && make -j${NUMCORE} -C src/backend/utils fmgroids.h \
 && cp src/backend/utils/fmgroids.h src/include/utils/fmgroids.h \
 && make -C src/bin/pg_config install \
 && make -C src/interfaces/libpq install \
 && make -C src/include install \
 && ldconfig \
 && rm -fr /tmp/postgresql

# install libpqxx
RUN git clone https://github.com/jtv/libpqxx /tmp/libpqxx \
 && (cd /tmp/libpqxx; git checkout 5b17abce5ac2b1a2f8278718405b7ade8bb30ae9) \
 && curl -L -o /tmp/libpqxx/config/config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=6b2374c79506ee82a8b440f6d1ca293e2e2e2463' \
 && curl -L -o /tmp/libpqxx/config/config.sub 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=6b2374c79506ee82a8b440f6d1ca293e2e2e2463' \
 && (cd /tmp/libpqxx; /tmp/libpqxx/configure --disable-documentation --with-pic) \
 && make -j${NUMCORE} -C /tmp/libpqxx \
 && make -C /tmp/libpqxx install \
 && ldconfig \
 && rm -fr /tmp/libpqxx

# install tbb
RUN git clone https://github.com/01org/tbb /tmp/tbb \
 && (cd /tmp/tbb; git checkout eb6336ad29450f2a64af5123ca1b9429ff6bc11d) \
 && make -j${NUMCORE} -C /tmp/tbb tbb_build_prefix=build \
 && cp /tmp/tbb/build/build_debug/*.so* /usr/local/lib \
 && cp /tmp/tbb/build/build_release/*.so* /usr/local/lib \
 && cp -r /tmp/tbb/include/* /usr/local/include \
 && ldconfig \
 && rm -fr /tmp/tbb

# install ed25519
RUN git clone git://github.com/hyperledger/iroha-ed25519.git /tmp/ed25519 \
 && (cd /tmp/ed25519; git checkout f42953c631fae93011612f6b1ee33f1f88c3f8af) \
 && cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DTESTING=OFF \
      -H/tmp/ed25519 \
      -B/tmp/ed25519/build \
 && cmake --build /tmp/ed25519/build --target install -- -j${NUMCORE} \
 && ldconfig \
 && rm -rf /tmp/ed25519

WORKDIR /opt/iroha

CMD ["/bin/bash"]
