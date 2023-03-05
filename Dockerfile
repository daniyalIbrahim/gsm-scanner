FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    libosmocore-dev \
    gnuradio-dev \
    gr-osmosdr \
    cmake \
    ca-certificates \
    software-properties-common \
    build-essential \
    make \
    swig \
    rtl-sdr \
    python3-dev \
    python3-pip \
    python3-docutils \
    python3-scapy \
    python3-decouple \
    python3-mysqldb \
    python3-six \
    wireshark
    

COPY ./gr-gsm ./gr-gsm

RUN cd ./gr-gsm \
    && mkdir build/ \
    && cd build/ \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -Wno-dev \
    && make "-j$(nproc)" \
    && make install

COPY ./catcher catcher/

COPY ./env  /catcher/.env

# Set up the SDR device
#RUN usermod -aG plugdev root && \
#    echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", MODE:="0666"' >> /etc/udev/rules.d/rtl-sdr.rules

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]