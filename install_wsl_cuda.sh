#!/bin/bash

# Step 1: Install GCC (Required for CUDA)
echo "Step 1: Installing GCC..."
sudo apt update -y
sudo apt install -y gcc

# Step 2: Install CUDA for Linux WSL-Ubuntu 2.0 x86_64
echo "Step 2: Installing CUDA..."
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin && \
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb && \
sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb && \
sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb && \
sudo apt-get update && \
sudo apt-get -y install cuda-toolkit-12-8

# Step 3: Set up PATH variables for CUDA
echo "Step 3: Setting up PATH for CUDA..."
# Check if the PATH entry already exists, then add it only if not
grep -qxF 'export PATH=/usr/local/cuda-12.8/bin${PATH:+:${PATH}}' ~/.bashrc || \
echo 'export PATH=/usr/local/cuda-12.8/bin${PATH:+:${PATH}}' >> ~/.bashrc
# Apply the changes to the current session
source ~/.bashrc

# Step 4: Install NVIDIA CUDA Toolkit
echo "Step 4: Installing NVIDIA CUDA Toolkit..."
sudo apt install -y nvidia-cuda-toolkit

# Step 5: Install NVIDIA Utilities for Desktop Environment
echo "Step 5: Installing NVIDIA Utilities for Desktop Environment..."
sudo apt install -y nvidia-utils-570 && \
sudo apt install -y nvidia-settings

# Check if NVIDIA utilities and CUDA installation are successful
echo "Checking NVIDIA installation..."
nvidia-smi

echo "CUDA installation and setup completed successfully!"
nvidia-settings
