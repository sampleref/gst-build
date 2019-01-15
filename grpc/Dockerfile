FROM nas2docker/gst-build:1.0

RUN apt-get -y install build-essential autoconf libtool pkg-config

RUN apt-get -y install libgflags-dev libgtest-dev

RUN apt-get -y install clang libc++-dev

# Install GRPC

RUN git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc

RUN cd grpc; git submodule update --init \
    && make \
    && make install

RUN cd grpc/third_party/protobuf; make install

# Latest CMake
RUN apt -y purge --auto-remove cmake

RUN mkdir -p /temp \
    && cd /temp \
    && wget https://github.com/Kitware/CMake/releases/download/v3.12.4/cmake-3.12.4-Linux-x86_64.sh \
    && mkdir -p /opt/cmake \
    && sh cmake-3.12.4-Linux-x86_64.sh --prefix=/opt/cmake \
    && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

