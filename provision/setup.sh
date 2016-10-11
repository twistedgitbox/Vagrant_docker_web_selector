#!/usr/bin/env bash

## Vagrant and Docker sometimes work better together if the user is in a docker group. Create the group.

# Creating Docker group and adding user to it if not done so already
if grep -q "^docker:" /etc/group
then
  echo "Adding docker group"
  groupadd docker > /dev/null 2>&1
fi
usermod -aG docker $USER > /dev/null 2>&1

#groupadd nobody > /dev/null 2>&1
#usermod -aG nobody $USER > /dev/null 2>&1

#sudo mkdir -p /usr/share/nginx/html/

# This program extracts necessary information from git to determine both the docker files and the web files served. Install git.

# Check if git is installed, if not, install.
if apt -q list installed git
  then
    echo "Git already installed"
  else
    echo "Installing Git"
    sudo apt-get install git -y > /dev/null 2>&1
  fi

# I like to know when the startup script is finished. It makes debugging easier later if we need to make changes.

echo "Startup script completed"
