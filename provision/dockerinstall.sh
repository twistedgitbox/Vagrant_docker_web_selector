#!/bin/bash

Check_Installed () {
if apt -q list installed $1
 then
   echo "$1 already installed"
 else
   echo "Installing $1"
   sudo apt-get install $1 -y > /dev/null 2>&1
 fi
}

echo "Starting 14.04 update and docker install"
sudo apt-get update -y > /dev/null 2>&1
echo "Updating 14.04"
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual -y > /dev/null 2>&1
echo "Adding extras"
Check_Installed apt-transport
Check_Installed ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D > /dev/null 2>&1
echo "Updating docker keyserver and repositories"
sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
echo "Updating sources list and updating"
sudo apt-get update -y > /dev/null 2>&1
sudo apt-get purge lxc-docker -y > /dev/null 2>&1
apt-cache policy docker-engine > /dev/null 2>&1
Check_Installed docker-engine


