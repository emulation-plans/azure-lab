#!/usr/bin/env bash

#Installing DotNet

wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

apt update
apt install apt-transport-https -y
apt install dotnet-sdk-3.1 -y

#Install Covenant
git clone --recurse-submodules https://github.com/cobbr/Covenant


