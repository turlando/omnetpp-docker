FROM ubuntu:jammy AS builder

RUN                                \
    apt-get update                 \
    &&                             \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC                     \
    apt install -y                 \
        curl                       \
        tar                        \
        gcc                        \
        g++                        \
        bison                      \
        flex                       \
        make                       \
        perl                       \
        python3                    \
        python3-numpy              \
        python3-scipy              \
        python3-pandas             \
        python3-matplotlib         \
        python3-posix-ipc          \
        qt5-qmake                  \
	qtbase5-dev                \
	qtbase5-dev-tools          \
    &&                             \
    rm -rf /var/lib/apt/lists/*

RUN                                                                                                          \
    curl -L -O https://github.com/omnetpp/omnetpp/releases/download/omnetpp-6.0/omnetpp-6.0-linux-x86_64.tgz \
    &&                                                                                                       \
    tar xvf omnetpp-6.0-linux-x86_64.tgz -C /opt                                                             \ 
    &&                                                                                                       \
    rm omnetpp-6.0-linux-x86_64.tgz

RUN                        \
    cd /opt/omnetpp-6.0    \
    &&                     \
    . ./setenv             \
    &&                     \
    ./configure            \
        WITH_OSG=no        \
        WITH_OSGEARTH=no   \
    &&                     \
    make base

################################################################################

FROM ubuntu:jammy

RUN                                \
    apt-get update                 \
    &&                             \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC                     \
    apt install -y                 \
	make                       \
        gcc                        \
	g++                        \
	qtbase5-dev                \
        libswt-gtk-4-java          \
	libwebkit2gtk-4.0-37       \
    &&                             \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/omnetpp-6.0/setenv         /opt/omnetpp/setenv
COPY --from=builder /opt/omnetpp-6.0/configure.user /opt/omnetpp/configure.user
COPY --from=builder /opt/omnetpp-6.0/Makefile.inc   /opt/omnetpp/Makefile.inc
COPY --from=builder /opt/omnetpp-6.0/Version        /opt/omnetpp/Version
COPY --from=builder /opt/omnetpp-6.0/bin            /opt/omnetpp/bin
COPY --from=builder /opt/omnetpp-6.0/lib            /opt/omnetpp/lib
COPY --from=builder /opt/omnetpp-6.0/include        /opt/omnetpp/include
COPY --from=builder /opt/omnetpp-6.0/ide            /opt/omnetpp/ide
COPY --from=builder /opt/omnetpp-6.0/images         /opt/omnetpp/images
COPY --from=builder /opt/omnetpp-6.0/misc           /opt/omnetpp/misc
COPY --from=builder /opt/omnetpp-6.0/samples        /opt/omnetpp/samples

COPY --chmod=755   ./omnetpp                        /usr/bin/omnetpp

RUN echo '/opt/omnetpp/lib' > /etc/ld.so.conf.d/omnetpp.conf && ldconfig