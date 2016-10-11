#!/bin/bash

# Running a vagrant provision repeatedly can cause the permissions in the docker container for NGINX to give the dreaded 403 error

# Since the simplest fix is 2 lines of code vs several to go in to check the docker permissions and file ownership concerns, a small script at the end of Vagrantfile to rebuild the NGINX container prevents this problem.
cd /vagrant/docker
docker-compose up -d --force-recreate
echo "NGINX is up and serving on port 8000"
echo "Use localhost:8000 to access or the IP address of your vagrant client."

