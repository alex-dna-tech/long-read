FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update 

RUN apt install -y --no-install-recommends \
    curl tmux vim git make cmake gcc g++ libz-dev libidn11-dev tzdata r-base python3 python3-pip && \
    set -o vi

WORKDIR /tmp

RUN RELEASE=2.18 && \
    curl -L https://github.com/lh3/minimap2/releases/download/v${RELEASE}/minimap2-${RELEASE}_x64-linux.tar.bz2 | tar -jxvf - && \
    mv ./minimap2-${RELEASE}_x64-linux/minimap2 /usr/local/bin/ && \
    rm -rf minimap2-${RELEASE}_x64-linux

RUN git clone https://github.com/lh3/miniasm && \
    cd miniasm && make && mv miniasm /usr/local/bin/ && \
    rm -rf ../miniasm/

RUN curl https://raw.githubusercontent.com/roblanf/minion_qc/master/MinIONQC.R > /usr/local/bin/MinIONQC.R && \
    echo "RScript MinIONQC.R \$*" > /usr/local/bin/minionqc && chmod u+x /usr/local/bin/minionqc && \
    Rscript -e 'install.packages(c("data.table", "futile.logger", "ggplot2", "optparse", "plyr", "readr", "reshape2", "scales", "viridis", "yaml"))'

RUN git clone https://github.com/sanger-pathogens/assembly-stats.git && \
    cd assembly-stats && mkdir build && cd build && cmake .. && \
    make && make test && make install && rm -rf ../../assembly-stats

RUN git clone https://github.com/fenderglass/Flye.git && \
    cd Flye &&  pip3 install setuptools && python3 setup.py install && \
    rm -rf ../Flye
    
RUN DIST=ont-guppy-cpu_3.3.0_linux64.tar.gz && mkdir /usr/local/share/apps && \
    cd /usr/local/share/apps && \
    curl -L https://mirror.oxfordnanoportal.com/software/analysis/${DIST} > ${DIST} && \
    tar -xzvf ${DIST} && rm ${DIST} && \
    cp -rs /usr/local/share/apps/ont-guppy-cpu/bin/guppy_* /usr/local/bin/

RUN git clone https://github.com/rrwick/Porechop.git && \
    cd Porechop && python3 setup.py install && \
    rm -rf ../Porechop

RUN RELEASE=0.7.0 && curl -O -L https://github.com/chanzuckerberg/shasta/releases/download/${RELEASE}/shasta-Linux-${RELEASE} && \
    chmod ugo+x shasta-Linux-${RELEASE} && mv shasta-Linux-${RELEASE} /usr/local/bin/shasta

RUN git clone --recursive https://github.com/lbcb-sci/racon.git racon && \
    cd racon && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && make install && rm -rf ../../racon

RUN RELEASE=1.24 && mkdir -p /usr/local/share/apps && cd $_ && \
    curl -O -L https://github.com/broadinstitute/pilon/releases/download/v${RELEASE}/pilon-${RELEASE}.jar && \
    echo "java -Xmx10G -jar /usr/local/share/apps/pilon/pilon-${RELEASE}.jar $*" >> /usr/local/bin/pilon && \
    chmod +x /usr/local/bin/pilon

RUN pip3 install nanofilt && pip3 install ont-fast5-api && \
    apt install -y mummer

RUN RELEASE=1.12 && apt install -y libncurses-dev libbz2-dev liblzma-dev && \
    curl -O -L https://github.com/samtools/samtools/releases/download/${RELEASE}/samtools-${RELEASE}.tar.bz2 && \
    tar xjvf samtools-${RELEASE}.tar.bz2 && rm samtools-${RELEASE}.tar.bz2 && cd samtools-${RELEASE} && \
    ./configure && make && make install && rm -rf ../samtools-${RELEASE}

RUN RELEASE=1.9 && \
    curl -O -L https://github.com/samtools/htslib/releases/download/${RELEASE}/htslib-${RELEASE}.tar.bz2 && \
    tar xjvf htslib-${RELEASE}.tar.bz2 && rm htslib-${RELEASE}.tar.bz2 && cd htslib-${RELEASE} && \
    ./configure && make && make install && rm -rf ../htslib-${RELEASE}


RUN RELEASE=1.0.12a && \
    curl -o Sniffles-${RELEASE}.tar.gz -L https://github.com/fritzsedlazeck/Sniffles/archive/refs/tags/v${RELEASE}.tar.gz && \
    tar xzvf Sniffles-${RELEASE}.tar.gz && rm Sniffles-${RELEASE}.tar.gz && cd Sniffles-${RELEASE} && \
    mkdir build && cd build && cmake .. && make && make install && \
    rm -rf ../../Sniffles-${RELEASE}

RUN LC_ALL=C.UTF-8 pip3 install git+https://github.com/rrwick/Minipolish.git

RUN LC_ALL=C.UTF-8 pip3 install pycoQC

RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh  && \
    bash Anaconda3-2021.05-Linux-x86_64.sh -b -p /usr/local/conda && \
    rm Anaconda3-2021.05-Linux-x86_64.sh && \
    printf 'PATH=/usr/local/cond/bin:$PATH\n' >> ~/.bash_profile

RUN /usr/local/conda/bin/conda create -n medaka -c conda-forge -c bioconda -y medaka

WORKDIR /mnt
