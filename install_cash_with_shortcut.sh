#!/bin/bash

# Step 1: Update and upgrade the system packages
echo "Step 1: Updating and upgrading system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Step 2: Install required development tools and dependencies
echo "Step 2: Installing build-essential, libraries, and development tools..."
sudo apt-get install -y build-essential libtool autotools-dev autoconf pkg-config libssl-dev libcrypto++-dev libevent-dev git automake

# Step 3: Download and install Boost 1.81.0
echo "Step 3: Installing Boost 1.81.0..."
wget https://archives.boost.io/release/1.81.0/source/boost_1_81_0.tar.bz2
tar --bzip2 -xf boost_1_81_0.tar.bz2
cd boost_1_81_0
./bootstrap.sh --prefix=/usr/local
sudo ./b2 install
cd ~

# Step 4: Configure environment variables for Boost
echo "Step 4: Setting up Boost environment variables..."
echo 'export BOOST_ROOT=/usr/local' >> ~/.bashrc
echo 'export CXXFLAGS="-I/usr/local/include $CXXFLAGS"' >> ~/.bashrc
echo 'export LDFLAGS="-L/usr/local/lib $LDFLAGS"' >> ~/.bashrc
source ~/.bashrc

# Step 5: Add PPA for Berkeley DB 4.8 (Auto-confirm addition)
echo "Step 5: Adding PPA for Berkeley DB 4.8..."
sudo add-apt-repository -y ppa:pivx/berkeley-db4
sudo apt-get update

# Step 6: Install additional dependencies
echo "Step 6: Installing additional libraries..."
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
sudo apt-get install -y libminiupnpc-dev
sudo apt-get install -y libzmq3-dev
sudo apt-get install -y libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools
sudo apt-get install -y libprotobuf-dev protobuf-compiler libcrypto++-dev

# Step 7: Clone the Zero Dynamics repository
echo "Step 7: Cloning Zero Dynamics repository..."
cd ~
git clone https://github.com/zero-dynamics/cash-core

# Step 8: Build and install the project
cd cash-core
echo "Step 8: Cloning and building Cash-Core project..."
./autogen.sh
./configure --enable-upnp-default --enable-avx2 --enable-gpu --enable-cuda
make -j$(nproc)
sudo make install

# Step 9: Create Desktop Shortcut
echo "Step 9: Creating desktop shortcut for Cash-Qt..."
cat > ~/Desktop/cash-qt.desktop <<EOL
[Desktop Entry]
Name=Cash-Qt
Comment=Zero Dynamics Cash-Qt GUI
Exec=/home/$USER/cash-core/src/qt/cash-qt
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Utility;
EOL

# Step 10: Set permissions for the shortcut
chmod +x ~/Desktop/cash-qt.desktop

# Step 11: Run the Cash-Qt GUI
echo "Step 11: Running the Cash-Qt GUI..."
/home/$USER/cash-core/src/qt/cash-qt

echo "Script completed successfully!"
