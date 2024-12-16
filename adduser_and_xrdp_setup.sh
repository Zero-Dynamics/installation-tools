#!/bin/bash

# Variables
USERNAME="usr"
PASSWORD="pwd"

# Step 1: Create the user and set their password
sudo useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Step 2: Add the user to the sudo group
sudo usermod -aG sudo "$USERNAME"

# Step 3: Grant passwordless sudo permissions
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USERNAME
sudo chmod 440 /etc/sudoers.d/$USERNAME

# Step 4: Update and upgrade the system, and install xrdp with xfce4
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y xrdp xfce4 xfce4-goodies

# Step 5: Backup and modify the xrdp configuration
sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak
sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini

# Step 6: Configure xfce4 as the default session
echo xfce4-session > /home/"$USERNAME"/.xsession
sudo chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.xsession

# Step 7: Modify the startwm.sh file to configure RDP to use xfce4
sudo cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh.bak  # Backup the original file
sudo sed -i 's/^test -x \/etc\/X11\/Xsession/#&/' /etc/xrdp/startwm.sh
sudo sed -i 's/^exec \/bin\/sh \/etc\/X11\/Xsession/#&/' /etc/xrdp/startwm.sh
echo "startxfce4" | sudo tee -a /etc/xrdp/startwm.sh

# Step 8: Restart the xrdp service to apply all changes
sudo systemctl restart xrdp

echo "User $USERNAME has been created, and xrdp with xfce4 has been installed and configured."
