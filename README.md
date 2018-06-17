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
export GST_PLUGIN_PATH=/usr/local/lib

# If unsure,
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:<GST-INSTALLATION>/linux_x86_64/lib
GST_PLUGIN_PATH=<GST-INSTALLATION>/linux_x86_64/lib
PATH=$PATH:<GST-INSTALLATION>/linux_x86_64/lib

#Python bindings - along with gst-python install,
Following - http://pygobject.readthedocs.io/en/latest/getting_started.html
sudo apt install python-gi python-gi-cairo python3-gi python3-gi-cairo gir1.2-gtk-3.0

