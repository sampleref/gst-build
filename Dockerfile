FROM ubuntu:16.04

# install required packages
RUN apt-get update
RUN apt-get -y install python-software-properties apt-utils vim htop dpkg-dev \
  openssh-server git-core wget nginx software-properties-common
RUN apt-add-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) multiverse"
RUN apt-get update

RUN apt-get install -y faac yasm
RUN apt-get install -y python-setuptools sudo

# create the ubuntu user
RUN addgroup --system ubuntu
RUN adduser --system --shell /bin/bash --gecos 'ubuntu' \
  --uid 1000 --disabled-password --home /home/ubuntu ubuntu
RUN adduser ubuntu sudo
RUN echo ubuntu:ubuntu | chpasswd
RUN echo "ubuntu ALL=NOPASSWD:ALL" >> /etc/sudoers
USER ubuntu
ENV HOME /home/ubuntu
WORKDIR /home/ubuntu

# Git config is needed so that cerbero can cleanly fetch some git repos
RUN git config --global user.email "ubuntu.user@xyz.com" \
    && git config --global user.name "ubuntu" \
    && git config --global url."https://".insteadOf git:// \
    && git config --global url."https://github.com/GStreamer".insteadOf git://anongit.freedesktop.org/gstreamer \
    && git config --global url."https://github.com/libav".insteadOf git://git.libav.org

RUN mkdir -p $HOME/.cerbero
ADD cerbero.cbc $HOME/.cerbero/cerbero.cbc
ADD nginx.conf /etc/nginx/nginx.conf

ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV GST_PLUGIN_PATH=/usr/local/lib
ENV PATH=$PATH:/usr/local/lib:/usr/local

# build gstreamer 1.0 from cerbero source
# the build commands are split so that docker can resume in case of errors
RUN git clone https://github.com/gstreamer/cerbero

# hack: to pass "-y" argument to apt-get install launched by "cerbero bootstrap"
RUN sed -i 's/apt-get install/apt-get install -y/g' cerbero/cerbero/bootstrap/linux.py
RUN cd cerbero; ./cerbero-uninstalled bootstrap

RUN cd cerbero; ./cerbero-uninstalled build \
  glib bison gstreamer-1.0

RUN sudo apt-get install -y python-dev
RUN cd cerbero; ./cerbero-uninstalled build \
  gst-plugins-base-1.0 gst-plugins-good-1.0

RUN cd cerbero; ./cerbero-uninstalled build \
  gst-plugins-bad-1.0 gst-plugins-ugly-1.0

RUN cd cerbero; ./cerbero-uninstalled build \
  gst-libav-1.0 gst-rtsp-server-1.0 openh264

RUN cd cerbero; rm -rf build/sources


# Examples
RUN git clone https://github.com/GStreamer/gst-rtsp-server.git

RUN cd gst-rtsp-server; ./autogen.sh; make

RUN git clone https://github.com/centricular/gstwebrtc-demos.git

ADD key.pem /home/ubuntu/gstwebrtc-demos/signalling/key.pem
ADD cert.pem /home/ubuntu/gstwebrtc-demos/signalling/cert.pem
