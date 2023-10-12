#!/bin/bash
msg()
{
numlines=$(tput lines)
echo -eq "\ec\e7\e[0;0H*****************************************"
echo -e "\e[2;0H          Work Setup Script 0.5"
echo -e "\e[3;0H*****************************************"
echo -e "\e[4;0H$1\n"
echo -e "\e[6;$((numlines))r\e[5;0H"
}

DIR="$( cd "$( dirname "$0" )" && pwd )"
HOMEDIR="$( cd ~ "$( dirname "$0" )" && pwd )"
sudo id -u

msg "Installing Dependencies 🏗️"
sudo apt update
sudo apt install git tmux tmuxp curl htop nvtop build-essential net-tools snap libxdo3 libva-drm2 libva-xll-2 libvdpaul gstreamer1.0-pipewire libnss3-tools gnupg2 nftables  -y

msg "Installing Spotify 🎶"
sudo snap install spotify

# ssh
msg "Installing OpenSSH 📡"
sudo apt install openssh-server -y
sudo systemctl enable ssh
udo ufw allow ssh

# vs code
msg "Installing Visual Studio Code 🤖"
curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code.deb

# rustdesk
msg "Installing RustDesk 🖥️"
curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep "browser_download_url.*x86_64.deb" | cut -d : -f 2,3 | tr -d \" | wget --output-document=rustdesk.deb -i - 
sudo dpkg -i rustdesk.deb
sleep 10

# cf warp
msg "Installing Cloudflare-Warp VPN 📶"
curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
sudo apt update 
sudo apt install cloudflare-warp -y


# miniconda 
msg "Installing Miniconda3 🐍"
curl -o conda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh conda.sh -b


# msg "Installing environment 🌄"
. ~/miniconda3/etc/profile.d/conda.sh
conda create --name ps python=3.11 -y
conda activate ps
pip install flask pyyaml
conda deactivate 
conda create --name jptb python=3.11 -y
conda activate jptb
pip install notebook tensorboard tensorboardX

# setup cf warp
. ~/.bashrc
msg "Authenticate Zero-Trust Team 🎗️"
echo y | warp-cli teams-enroll gjamesgoenawan

export PATH="$HOMEDIR/miniconda3/bin:"$"PATH"
conda init
conda config --set auto_activate_base false

rm code.deb
rm conda.sh
rm rustdesk.deb

msg "🚀🚀 COMPLETE 🚀🚀"