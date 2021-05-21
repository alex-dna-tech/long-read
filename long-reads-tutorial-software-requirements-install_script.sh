#!/bin/bash


# essential installs
sudo apt-get update 
sudo apt-get install --assume-yes vim
sudo apt-get install --assume-yes python-pip python3 python3-pip
sudo apt-get install --assume-yes git
sudo apt-get install --assume-yes r-base
sudo apt-get install --assume-yes cmake
sudo apt-get install --assume-yes zliblg
sudo apt-get install --assume-yes virtualbox-guest-utils

touch ~/.bash_profile
printf "\n. ~/.bash_profile\n" >> ~/.bashrc
 set aliases globally
sudo printf "\n#custom aliases\nalias l='ll'\nalias ..='cd ..'\nalias vi='vim'\n\n" >> ~/.profile


# github repos
mkdir ~/github
cd ~/github


git clone https://github.com/lh3/minimap2.git
cd minimap2 && make
printf 'PATH=/home/course_user/github/minimap2:$PATH\n' >>  ~/.bash_profile

cd ~/github
git clone https://github.com/lh3/miniasm
cd miniasm && make
printf 'PATH=/home/course_user/github/miniasm:$PATH\n' >>  ~/.bash_profile

cd ~/github
git clone https://github.com/roblanf/minion_qc
printf 'PATH=/home/course_user/github/minion_qc:$PATH\n' >>  ~/.bash_profile

git clone https://github.com/sanger-pathogens/assembly-stats.git
cd assembly-stats
mkdir build
cd build
cmake ..
make
make test
make install

cd ~/github
git clone https://github.com/fenderglass/Flye.git
cd Flye
make
printf 'PATH=/home/course_user/github/Flye/bin:$PATH\n' >>  ~/.bash_profile

# install needed R pacakges
sudo su - -c "R -e \"install.packages(c('data.table','futile.logger','ggplot2','optparse','plyr','readr','reshape2','scales','viridis','yaml','gridextra'))\""

# install Guppy
mkdir /usr/local/share/apps
cd /usr/local/share/apps
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-cpu_3.3.0_linux64.tar.gz
sudo tar -xzvf ont-guppy-cpu_3.3.0_linux64.tar.gz
printf 'PATH=/usr/local/share/apps/ont-guppy-cpu/bin:$PATH\n' >> ~/.bash_profile 

# install porechop
cd ~/github
git clone https://github.com/rrwick/Porechop.git
cd Porechop
sudo python3 setup.py install

# install nanofilt
pip3 install nanofilt
pip3 install nanofilt --upgrade

# install fastqc and change memory to 1g (single thread) and 500m (threaded)
sudo apt-get install --assume-yes fastqc
sed 's/Xmx250m/Xmx2g/' /usr/bin/fastqc|sed 's/250/500/' > /tmp/fastqc
sudo mv /tmp/fastqc /usr/bin
sudo chmod 775 /usr/bin/fastqc

sudo apt-get install --assume-yes mummer

# install shasta
cd ~/github
git clone https://github.com/chanzuckerberg/shasta.git
sudo shasta/scripts/InstallPrerequisites-Ubuntu.sh
mkdir shasta-build
cd shasta-build
cmake ../shasta
make all
make install
printf 'PATH=/home/course_user/github/shasta-build/shasta-install/bin:$PATH\n' >> ~/.bash_profile

# racon
cd ~/github
wget https://github.com/isovic/racon/releases/download/1.4.3/racon-v1.4.3.tar.gz
tar -xzvf racon-v1.4.3.tar.gz
cd racon-v1.4.3
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
make install

# install pilon
cd /usr/local/share/apps
sudo mkdir pilon
cd pilon
wget https://github.com/broadinstitute/pilon/releases/download/v1.23/pilon-1.23.jar
sudo chmod 775 /usr/local/share/apps/pilon-1.23.jar
sudo touch /usr/bin/pilon
sudo echo "java -Xmx10G -jar /usr/local/share/apps/pilon/pilon-1.23.jar $@" >> /usr/bin/pilon
sudo chmod +x /usr/bin/pilon

# install Bondage
sudo apt-get install --assume-yes qt5-default
cd /usr/local/share/apps
sudo mkdir bandage
cd bandage
wget https://github.com/rrwick/Bandage/releases/download/v0.8.1/Bandage_Ubuntu_dynamic_v0_8_1.zip
unzip Bandage_Ubuntu_dynamic_v0_8_1.zip
printf 'PATH=/usr/local/share/apps/bandage:$PATH\n' >> ~/.bash_profile

# install IGV
cd /usr/local/share/apps
wget https://data.broadinstitute.org/igv/projects/downloads/2.7/IGV_Linux_2.7.2.zip
unzip IGV_Linux_2.7.2.zip
sudo ln -s /usr/local/share/apps/IGV_Linux_2.7.2/igv.sh /usr/bin/igv

# install medaka
sudo pip3 install medaka

# install samtools
cd /tmp
wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
tar -xvf samtools-1.9.tar.bz2
cd samtools-1.9
./configure --prefix=/usr/local/share/apps/samtools
sudo make 
sudo make install
printf 'PATH=/usr/local/share/apps/samtools/bin:$PATH\n' >> ~/.bash_profile

# install Sniffles
cd /usr/local/share/apps
wget https://github.com/fritzsedlazeck/Sniffles/archive/master.tar.gz -O Sniffles.tar.gz
tar xzvf Sniffles.tar.gz
cd Sniffles-master/
mkdir -p build/
cd build/
cmake ..
make
printf 'PATH=/usr/local/share/apps/Sniffles-master/bin/sniffles-core-1.0.11:$PATH' >> ~/.bash_profile

# install htslib
cd /tmp
wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2
tar -xvf htslib-1.9.tar.bz2
cd htslib-1.9
sudo ./configure
sudo make 
sudo make install

# install ont_fast5_api
pip3 install ont-fast5-api

cd ~/github
git clone https://github.com/rrwick/Minipolish.git
pip3 install ./Minipolish

sudo apt-get install bwa
sudo chown course_user:course_user .bash_profile

# install pycoQC
pip3 install pycoQC

printf "\nexport PATH\n" >> ~/.bash_profile
