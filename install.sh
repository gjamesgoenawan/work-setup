#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
HOMEDIR="$( cd ~ "$( dirname "$0" )" && pwd )"

sudo apt update
sudo apt install git tmux tmuxp curl htop nvtop build-essential net-tools openssh-server snap -y
sudo snap install spotify

# ssh
sudo systemctl enable ssh
udo ufw allow ssh

# vs code
curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code.deb

# miniconda 
curl -o conda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh conda.sh -b
export PATH="$HOMEDIR/miniconda3/bin:"$"PATH"
conda init
conda config --set auto_activate_base false

# cf warp
curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
sudo apt-get update && sudo apt-get install cloudflare-warp

# rustdesk
curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep "browser_download_url.*x86_64.deb" | cut -d : -f 2,3 | tr -d \" | wget --output-document=rustdesk.deb -i - 
sudo dpkg -i rustdesk.deb

# setup server
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
echo y | warp-cli teams-enroll gjamesgoenawan
