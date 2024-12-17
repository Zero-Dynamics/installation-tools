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

# Step 4: Update and upgrade the system, and install xrdp with KDE Plasma
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y xrdp kubuntu-desktop

# Step 5: Backup and modify the xrdp configuration
sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak
sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini

# Step 6: Configure KDE as the default session
echo "startplasma-x11" > /home/"$USERNAME"/.xsession
sudo chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.xsession

# Step 7: Modify the startwm.sh file to configure RDP to use KDE Plasma
sudo cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh.bak  # Backup the original file
sudo sed -i 's/^test -x \/etc\/X11\/Xsession/#&/' /etc/xrdp/startwm.sh
sudo sed -i 's/^exec \/bin\/sh \/etc\/X11\/Xsession/#&/' /etc/xrdp/startwm.sh
echo "startplasma-x11" | sudo tee -a /etc/xrdp/startwm.sh

# Step 8: Add a PolicyKit rule to allow network control without prompts
POLKIT_RULE_FILE="/etc/polkit-1/rules.d/50-networkmanager.rules"
sudo bash -c "cat > $POLKIT_RULE_FILE" <<EOF
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.NetworkManager.network-control" &&
        subject.isInGroup("sudo")) {
        return polkit.Result.YES;
    }
});
EOF
sudo chmod 644 $POLKIT_RULE_FILE

# Step 9: Restart services to apply changes
sudo systemctl restart polkit
sudo systemctl restart xrdp

echo "User $USERNAME has been created, and xrdp with KDE Plasma has been installed and configured."
echo "Network control permissions have been fixed for the sudo group."
