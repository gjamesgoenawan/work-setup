#!/bin/bash
msg()
{
numlines=$(tput lines)
echo -eq "\ec\e7\e[0;0H*****************************************"
echo -e "\e[2;0H          Work Setup Script 1.0"
echo -e "\e[3;0H*****************************************"
echo -e "\e[4;0H$1\n\n\n\n\n"
echo -e "\e[6;$((numlines))r\e[5;0H"
}



DIR="$( cd "$( dirname "$0" )" && pwd )"
HOMEDIR="$( cd ~ "$( dirname "$0" )" && pwd )"
sudo id -u

msg "Installing Dependencies 🏗️"
sudo apt update -qq
sudo apt install git tmux tmuxp curl htop nvtop build-essential net-tools snap -y -qq

msg "Installing Spotify 🎶"
sudo snap install spotify

# ssh
msg "Installing OpenSSH 📡"
sudo apt install openssh-server -y -qq
sudo systemctl enable ssh
udo ufw allow ssh

# vs code
msg "Installing Visual Studio Code 🤖"
curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code.deb

# miniconda 
msg "Installing Miniconda3 🐍"
curl -o conda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh conda.sh -b
export PATH="$HOMEDIR/miniconda3/bin:"$"PATH"
conda init
conda config --set auto_activate_base false

# cf warp
msg "Installing Cloudflare-Warp VPN 📶"
curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
sudo apt-get update -qq && sudo apt-get install cloudflare-warp -qq 

# rustdesk
msg "Installing RustDesk 🖥️"
curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep "browser_download_url.*x86_64.deb" | cut -d : -f 2,3 | tr -d \" | wget --output-document=rustdesk.deb -i - 
sudo dpkg -i rustdesk.deb

# setup server
msg "Installing environment 🌄"
. ~/miniconda3/etc/profile.d/conda.sh
conda create --name ps python=3.11 -y
conda activate ps
pip install flask pyyaml
conda deactivate 
conda create --name jptb python=3.11 -y
conda activate jptb
pip install notebook tensorboard tensorboardX
conda init bash

# setup cf warp
msg "Authenticate Zero-Trust Team 🎗️"
echo y | warp-cli teams-enroll gjamesgoenawan
