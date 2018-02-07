FROM debian:jessie

# Install Bitlbee-purple with facebook
RUN apt-get update && apt-get install -y curl \
  && echo 'deb http://code.bitlbee.org/debian/master/jessie/amd64/ ./' \
    > /etc/apt/sources.list.d/bitlbee.list \
  && echo 'deb http://download.opensuse.org/repositories/home:/jgeboski/Debian_8.0 ./' \
    > /etc/apt/sources.list.d/jgeboski.list \
  && curl https://code.bitlbee.org/debian/release.key | apt-key add - \
  && curl https://jgeboski.github.io/obs.key | apt-key add - \
  && apt-get update \
  && apt-get install -y bitlbee-libpurple bitlbee-facebook \
  && apt-get remove --purge -y curl \
  && rm -rf /var/lib/apt/lists/*

# Install Hangout support
RUN BUILD_PACKAGES="libpurple-dev libjson-glib-dev libglib2.0-dev \
    libprotobuf-c-dev protobuf-c-compiler mercurial make gcc" \
  && apt-get update && apt-get install -y $BUILD_PACKAGES \
  && hg clone https://bitbucket.org/EionRobb/purple-hangouts/ \
  && cd purple-hangouts \
  && make && make install \
  && apt-get remove --purge -y $BUILD_PACKAGES \
  && cd .. && rm -rf purple-hangouts \
  && rm -rf /var/lib/apt/lists/*

# Runtimes deps
RUN apt-get update && apt-get install -y libpurple0 libjson-glib-1.0-0 libglib2.0-0 \
    libprotobuf-c1 \
  && rm -rf /var/lib/apt/lists/*

COPY bitlbee.conf /etc/bitlbee/bitlbee.conf

EXPOSE 6667

WORKDIR /
ENTRYPOINT [ "/usr/sbin/bitlbee" ]
