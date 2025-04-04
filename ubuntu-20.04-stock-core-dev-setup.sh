#!/bin/bash

echo "This script will install the packages and libraries required to build the Stock Core wallet dependancies"
echo "Do you wish to clone 'stock-core' and build the dependancies for the master branch as well?"

read -p 'Enter Y for yes or anything else to decline: ' uservar

if [ $uservar == "Y" ]
then
  echo "The script will clone Stock Core and attempt to build the depends"
else
  echo "The script will not clone Stock Core"
fi

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y git build-essential libcurl3-dev libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libunbound-dev libattr1-dev libgmp-dev libsodium-dev libseccomp-dev libcap-dev cmake

sudo add-apt-repository -y ppa:mhier/libboost-latest
sudo apt update

sudo apt install -y libboost1.81-all-dev

sudo apt-get install -y libminiupnpc-dev
sudo apt-get install -y libzmq3-dev


#install qt5
sudo apt-get install -y libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqt5charts5-dev

sudo apt-get install -y libqrencode-dev curl


#install unbound
mkdir tmp
cd tmp
wget https://nlnetlabs.nl/downloads/unbound/unbound-1.7.3.tar.gz
tar xvfz unbound-1.7.3.tar.gz
cd unbound-1.7.3/
./configure
make -j$(nproc)
sudo make install
cd .. && cd ..
rm -rf tmp

#install db
sudo apt-get install -y libdb-dev libdb++-dev

#install zmq so we can run our python tests
sudo apt-get install -y python3-zmq

if [ $uservar == "Y" ]
then
  cd ~
  #clone and build all the deps required
  git clone https://github.com/zero-dynamics/stock-core
  cd stock-core
  git checkout master
  cd depends
  make
  cd ..
  ./autogen.sh
  ./configure --enable-debug --enable-tests --prefix=`pwd`/depends/`uname -m`-pc-linux-gnu
  make -j$(nproc)
  sudo make install
fi
