#!/bin/bash

# Create alternative html and logs directory for future use
mkdir -p /var/www/example.com/html/ /var/www/example.com/logs/

# Some nginx sets the default user as nobody, use if necessary
adduser nobody
sudo chown -R nobody:nobody /var/www/example.com/html
sudo chmod 755 /var/www

echo "Adding docker and www groups to the user"
sudo groupadd docker # > /dev/null 2>&1
sudo usermod -aG docker $USER # > /dev/null 2>&1
sudo groupadd www # > /dev/null 2>&1
sudo usermod -aG www > # /dev/null 2>&1

#chown -R $USER:$USER /var/www/html





