#
# Minimum Docker image to build Android AOSP
#
FROM ubuntu:16.04

MAINTAINER Aurelien BOUIN <aurelien.bouin@captina.dev>

# /bin/sh points to Dash by default, reconfigure to use bash until Android
# build becomes POSIX compliant

# Keep the dependency list as short as reasonable
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y bc build-essential ccache curl g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop m4 openjdk-8-jdk pngcrush repo rsync schedtool squashfs-tools xsltproc zip zlib1g-dev bison gperf libxml2-utils make zlib1g-dev liblz4-tool libncurses5 lunch unzip clang

RUN apt-get install -y gcc-arm-linux-gnueabihf python-mako gettext


#freescale requirements
RUN apt-get install -y uuid uuid-dev lzop gperf liblz-dev liblzo2-2 \
liblzo2-dev u-boot-tools flex mtd-utils android-tools-fsutils bc

RUN apt-get install -y gdisk cpio

RUN apt-get update && apt-get install -y sudo tree

RUN apt-get update && apt-get install -y bsdmainutils cgpt

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
#    dpkg-reconfigure -p critical dash

ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

ADD https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz /tmp/
RUN tar -xf /tmp/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz -C /opt/
RUN rm /tmp/gcc-arm-*.xz
RUN echo "export AARCH64_GCC_CROSS_COMPILE=/opt/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/bin/aarch64-linux-gnu-" | tee -a /etc/environment

# Install latest version of JDK
# See http://source.android.com/source/initializing.html#setting-up-a-linux-build-environment
WORKDIR /tmp

# All builds will be done by user aosp
COPY gitconfig /root/.gitconfig
COPY ssh_config /root/.ssh/config

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/tmp/ccache", "/aosp"]

# Work in the build directory, repo is expected to be init'd here
WORKDIR /aosp

COPY docker_entrypoint.sh /root/docker_entrypoint.sh
ENTRYPOINT ["/root/docker_entrypoint.sh"]
