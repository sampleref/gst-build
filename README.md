# gst-build

docker build -t nas2docker/gst-build .

docker run -it nas2docker/gst-build



# Ref Links
https://github.com/GStreamer/gst-python

https://anongit.freedesktop.org/git/gstreamer/

https://github.com/davibe/gstreamer-docker/blob/master/Dockerfile

# Search Text in Any File
grep -rnw '/path/to/somewhere/' -e 'pattern'

# Export variables
set  - prefix = "/usr/local" - in file $HOME/.cerbero/cerbero.cbc
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
