FROM nas2docker/gst-build:exmpl

# install required packages
RUN apt-get update
RUN apt-get -y install python3-pip \
    && pip3 install websocket \
    && pip3 install websocket-client

ADD nginx.conf /etc/nginx/nginx.conf

