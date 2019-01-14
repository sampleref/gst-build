FROM ubuntu:16.04

# install required packages
RUN apt-get update
RUN apt-get -y install python-software-properties apt-utils vim htop dpkg-dev \
  openssh-server git-core wget nginx software-properties-common
RUN apt-add-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) multiverse"
RUN apt-get update

RUN apt-get install -y faac yasm python-setuptools python-dev

# Git config is needed so that cerbero can cleanly fetch some git repos
RUN git config --global user.email "ndn.user@xyz.com" \
    && git config --global user.name "ndn" \
    && git config --global url."https://".insteadOf git:// \
    && git config --global url."https://github.com/GStreamer".insteadOf git://anongit.freedesktop.org/gstreamer \
    && git config --global url."https://github.com/libav".insteadOf git://git.libav.org

RUN mkdir -p /root/.cerbero
ADD cerbero.cbc /root/.cerbero/cerbero.cbc

ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV GST_PLUGIN_PATH=/usr/local/lib
ENV PATH=$PATH:/usr/local/lib:/usr/local

# build gstreamer 1.0 from cerbero source
# the build commands are split so that docker can resume in case of errors
RUN git clone -b 1.14 https://github.com/gstreamer/cerbero

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
  gst-libav-1.0 gst-rtsp-server-1.0 openh264

RUN cd cerbero; rm -rf build/sources

RUN cd cerbero; ldconfig
