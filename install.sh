#!/bin/sh

msg()
{
numlines=$(tput lines)
echo -eq "\ec\e7\e[0;0H*****************************************"
echo -e "\e[2;0H      Gejems Work Setup Script 0.7"
echo -e "\e[3;0H*****************************************"
echo -e "\e[4;0H$1\n"
echo -e "\e[6;$((numlines))r\e[5;0H"
}

DIR="$( cd "$( dirname "$0" )" && pwd )"
HOMEDIR="$( cd ~ "$( dirname "$0" )" && pwd )"
CURRENTVER=$(lsb_release -rs)
sudo id -u


msg "Installing Dependencies 🏗️"
sudo apt update
sudo apt install dconf-cli curl git tmux tmuxp curl htop build-essential net-tools snap libxdo3 conky -y

cat preferences/gnome-terminal.preferences | dconf load /org/gnome/terminal/
if [ "$(printf "23.04\n$CURRENTVER" | sort -t '.' -k 1,1n -k 2,2n | tail -n 1)" = "$CURRENTVER" ]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
else
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
fi


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
rm code.deb

# rustdesk
msg "Installing RustDesk 🖥️"
curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep "browser_download_url.*x86_64.deb" | cut -d : -f 2,3 | tr -d \" | wget --output-document=rustdesk.deb -i - 
sudo dpkg -i rustdesk.deb
sudo apt --fix-broken install -y
sleep 10
rm rustdesk.deb

# cf warp
msg "Installing Cloudflare-Warp VPN 📶"
curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
sudo apt update 
sudo apt install cloudflare-warp -y
sudo apt --fix-broken install -y
sleep 10


# miniconda 
msg "Installing Miniconda3 🐍"
curl -o conda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh conda.sh -b
rm conda.sh

# msg "Installing environment 🌄"
. ~/miniconda3/etc/profile.d/conda.sh
conda create --name ps python=3.11 -y
conda activate ps
pip install flask pyyaml pynvml
conda deactivate 
conda create --name jptb python=3.11 -y
conda activate jptb
pip install notebook tensorboard tensorboardX

# Configure Conky
msg "Configuring Conky"
git clone https://github.com/jxai/lean-conky-config.git
cp preferences/lean_conky_configuration.conf lean-conky-config/local.conf

# setup cf warp
msg "Authenticate Zero-Trust Team 🎗️"
echo y | warp-cli teams-enroll gjamesgoenawan
sleep 5

. ~/miniconda3/etc/profile.d/conda.sh
conda init
conda config --set auto_activate_base false

msg "🚀🚀 COMPLETE 🚀🚀"
