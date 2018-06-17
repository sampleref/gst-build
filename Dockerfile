FROM ubuntu:16.04

# install required packages
RUN apt-get update
RUN apt-get -y install python-software-properties apt-utils vim htop dpkg-dev \
  openssh-server git-core wget software-properties-common
RUN apt-add-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) multiverse"
RUN apt-get update

RUN apt-get install -y faac yasm

# Git config is needed so that cerbero can cleanly fetch some git repos
RUN git config --global user.email "wire.chakri@gmail.com"
RUN git config --global user.name "SampleRef"

# build gstreamer 1.0 from cerbero source
# the build commands are split so that docker can resume in case of errors
RUN git clone -b 1.14 git://anongit.freedesktop.org/gstreamer/cerbero
# hack: to pass "-y" argument to apt-get install launched by "cerbero bootstrap"
RUN sed -i 's/sudo apt-get install/apt-get install -y/g' cerbero/cerbero/bootstrap/linux.py
RUN cd cerbero; ./cerbero-uninstalled bootstrap

RUN cd cerbero; ./cerbero-uninstalled build \
  glib bison gstreamer-1.0

RUN cd cerbero; ./cerbero-uninstalled build \
  gst-plugins-base-1.0 gst-plugins-good-1.0

RUN cd cerbero; ./cerbero-uninstalled build \
  gst-plugins-bad-1.0 gst-plugins-ugly-1.0

RUN cd cerbero; ./cerbero-uninstalled build \
  gst-libav-1.0 gst-rtsp-server-1.0 openh264 gst-python-1.0

RUN git clone -b 1.14 https://github.com/GStreamer/gst-python.git \
    && cd gst-python \
    && export LD_LIBRARY_PATH=/cerbero/build/dist/linux_x86_64/lib \
    && export PKG_CONFIG_PATH=/cerbero/build/dist/linux_x86_64/lib/pkgconfig \
    && export GST_PLUGIN_PATH=/cerbero/build/dist/linux_x86_64/lib \
    && export PATH=$PATH:/cerbero/build/dist/linux_x86_64/lib:/cerbero/build/dist/linux_x86_64 \
    && ./autogen.sh \
    && make \
    && make install

ENTRYPOINT ["/bin/bash"]