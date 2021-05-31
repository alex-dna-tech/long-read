FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y --no-install-recommends \
    curl git tzdata r-base python3 python3-pip

WORKDIR /tmp

RUN curl -L https://github.com/lh3/minimap2/releases/download/v2.18/minimap2-2.18_x64-linux.tar.bz2 | tar -jxvf - && \
mv ./minimap2-2.18_x64-linux/minimap2 /usr/local/bin/minimap2
