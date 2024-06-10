FROM phusion/baseimage:jammy-1.0.1

## Install nimble and move all config files to /etc/nimble.conf
##
RUN    echo "deb http://nimblestreamer.com/ubuntu jammy/" > /etc/apt/sources.list.d/nimble.list \
    && curl -L -s http://nimblestreamer.com/gpg.key | apt-key add - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y nimble \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y nimble-srt \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Configuration volume
##
VOLUME /etc/nimble

## Cache volume
##
VOLUME /var/cache/nimble

## WMS panel username and password
## Only required for first time registration
##
ENV WMSPANEL_USER	""
ENV WMSPANEL_PASS	""
ENV WMSPANEL_SLICES	""

## Service configuration
##
ADD files/my_init.d	/etc/my_init.d
ADD files/service	/etc/service

EXPOSE 1935 8081 8086
