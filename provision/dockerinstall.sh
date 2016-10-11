#!/bin/bash
echo "Starting 14.04 update and docker install"
sudo apt-get update -y >/dev/null 2>&1
echo "Updating 14.04"
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual -y >/dev/null 2>&1
echo "Adding extras"
sudo apt-get install apt-transport-https ca-certificates -y >/dev/null 2>&1
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >/dev/null 2>&1
echo "Updating docker keyserver and repositories"
sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
echo "Updating sources list and updating"
sudo apt-get update -y >/dev/null 2>&1
sudo apt-get purge lxc-docker -y >/dev/null 2>&1
apt-cache policy docker-engine >/dev/null 2>&1
sudo apt-get install docker-engine -y >/dev/null 2>&1
echo "Installing latest docker-engine"
