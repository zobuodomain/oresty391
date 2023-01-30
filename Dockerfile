# Dockerfile - Ubuntu Jammy
# https://github.com/openresty/docker-openresty

FROM ubuntu:jammy

LABEL maintainer="Evan Wies <evan@neomantra.net>"

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin/:/usr/local/openresty/nginx/sbin/:/usr/local/openresty/bin/

# 1) Install apt dependencies & update system

RUN apt update
RUN apt upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install inotify-tools -y
RUN apt-get install -y watchdog
RUN apt-get install -y python3-watchdog
RUN apt-get install python3-pip -y
RUN apt update
RUN apt upgrade -y
RUN apt-get install net-tools
RUN apt-get install build-essential libpcre3 libpcre3-dev libssl-dev -y
RUN apt-get install -y autoconf curl libcurl4-gnutls-dev libxslt-dev libreadline6-dev
RUN apt-get install zlib1g zlib1g-dev -y
RUN apt-get install -y libgd-dev
RUN apt-get install libxml2-dev libxslt1-dev -y
RUN apt-get install libdevil1c2 libdevil-dev -y
RUN apt-get install libperl-dev -y
RUN apt-get install python3 -y
RUN apt-get install -y ffmpeg
RUN apt-get install -y libavformat-dev
RUN apt-get install -y libavcodec-dev
RUN apt-get install -y libavutil-dev
RUN apt-get install -y libavfilter-dev
RUN apt-get install -y libswscale-dev
RUN apt-get install -y libjpeg-dev
RUN apt-get install -y default-libmysqlclient-dev
RUN apt-get install -y python3-lxml
RUN apt-get install libdbd-mysql-perl -y
RUN apt-get install gpac -y
RUN apt-get install -y net-tools
RUN apt-get install linux-kernel-headers
RUN apt-get update && apt-get install --yes flex
RUN apt-get update && apt-get install --yes bison
RUN apt-get update && apt-get install --yes libsodium23 libsodium-dev
RUN apt update -y
RUN apt-get install git -y
RUN apt-get install -y wget

# 2) Git clone all the required modules

RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git
RUN git clone https://github.com/arut/nginx-mtask-module.git
RUN git clone https://github.com/arut/nginx-mysql-module.git
RUN git clone https://github.com/alibaba/nginx-http-slice.git
RUN git clone https://github.com/limithit/ngx_dynamic_limit_req_module.git
RUN git clone https://github.com/nginx-modules/ngx_extravars.git
RUN git clone https://github.com/kaltura/nginx-vod-module.git
RUN git clone https://github.com/dannote/socks-nginx-module

# 3) Download and build Openresty

RUN wget https://openresty.org/download/openresty-1.21.4.1.tar.gz
RUN tar -xf openresty-1.21.4.1.tar.gz
RUN rm openresty-1.21.4.1.tar.gz
RUN cd openresty-1.21.4.1
RUN cd openresty-1.21.4.1 && ./configure --with-file-aio --with-http_addition_module --with-threads --add-module=../n>
RUN cd openresty-1.21.4.1 && make
RUN cd openresty-1.21.4.1 && make install

# 4) Run Openresty

# TODO: remove any other apt packages?
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
