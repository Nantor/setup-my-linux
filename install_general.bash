#!/bin/bash

## temp-file for downloading packs
vsc_tmp=$(mktemp)

## update system
sudo apt update
sudo apt -y upgrade

## install packs
sudo apt -y install git gcc perl make chromium-browser firefox curl gimp apt-transport-https ca-certificates software-properties-common filezilla openjdk-11-jdk openjdk-11-source update-manager

## install docker and docker-compose
curl -fsSL get.docker.com | sudo sh
sudo usermod -aG docker $(whoami)
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

## install nodejs
wget -qO - https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "" > ~/.profile
echo "export PATH=~/.npm-global/bin:\$PATH" > ~/.profile
source ~/.profile

## install Visual Studio Code
wget -O $vsc_tmp https://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i $vsc_tmp
sudo apt-get install -f

## install JetBrains PyCharm
wget -O $vsc_tmp $(curl -s 'https://data.services.jetbrains.com/products/releases?code=PCC&latest=true&type=release' | python3 -c "import sys, json; print(json.load(sys.stdin)['PCC'][0]['downloads']['linux']['link'])")
sudo tar xf $vsc_tmp -C /opt/
sudo ln -s /opt/pycharm-community-*/bin/pycharm.sh /usr/bin/pycharm
cat <<EOT | sudo tee "/usr/bin/pycharm-update"
#!/bin/bash
sudo rm -fR /opt/pycharm-community-*
sudo rm -f /usr/bin/pycharm
vsc_tmp=\$(mktemp)
wget -O \$vsc_tmp \$(curl -s 'https://data.services.jetbrains.com/products/releases?code=PCC&latest=true&type=release' | python3 -c "import sys, json; print(json.load(sys.stdin)['PCC'][0]['downloads']['linux']['link'])")
sudo tar xf \$vsc_tmp -C /opt/
sudo ln -s /opt/pycharm-community-*/bin/pycharm.sh /usr/bin/pycharm
EOT
sudo chmod +x /usr/bin/pycharm-update

## install JetBrains IntelliJ IDEA
wget -O $vsc_tmp $(curl -s 'https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release' | python3 -c "import sys, json; print(json.load(sys.stdin)['IIC'][0]['downloads']['linuxWithoutJDK']['link'])")
sudo tar xf $vsc_tmp -C /opt/
sudo ln -s /opt/idea-IC-*/bin/idea.sh /usr/bin/idea
cat <<EOT | sudo tee "/usr/bin/idea-update"
#!/bin/bash
sudo rm -fR /opt/idea-IC-*
sudo rm -f /usr/bin/idea
vsc_tmp=\$(mktemp)
wget -O \$vsc_tmp \$(curl -s 'https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release' | python3 -c "import sys, json; print(json.load(sys.stdin)['IIC'][0]['downloads']['linuxWithoutJDK']['link'])")
sudo tar xf \$vsc_tmp -C /opt/
sudo ln -s /opt/idea-IC-*/bin/idea.sh /usr/bin/idea
EOT
sudo chmod +x /usr/bin/idea-update

## install Google Chrome
wget -O vsc_tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i $vsc_tmp
sudo apt-get install -f

## clean up
sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove
sudo apt -y autoclean
