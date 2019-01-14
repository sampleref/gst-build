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

