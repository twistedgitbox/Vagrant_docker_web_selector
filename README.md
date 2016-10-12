##<span style="color:cyan">Vagrant Docker Web Selector & Provisioner</span>

###<span style="color:darkcyan">What is it for?</span>

This simple test is for use with a vagrant instance. This is an explaned version
of the [simple_vagrant_docker_web_provisioner](https://github.com/twistedgitbox/simple_vagrant_docker_web_provisioner)

Using the git repositories located in the `/provision` folder in the file
`public_gitrepos_to_vagrant_dir.sh` it downloads public git repositories into
the following folders:

**For repositories marked `WEB`** the repository is downloaded into the
`/vagrant/web` folder on the Vagrant guest.

**For repositories marked `DOCKER`** the repository is downloaded into the
`/vagrant/docker` folder on the Vagrant guest. The docker-container is then
started using the `docker-compose.yml` file in the folder.

(*note: this does require a docker-compose folder to exist and to be in the root directory of the designated `DOCKER` repository*)

This version uses `docker-compose.yml` in Version 2 format as well. This is because
the Vagrantfile uses the `ubuntu/trusty64` image. It also installs the latest
version of docker and docker-compose.

###<span style="color:darkcyan">Instructions</span>

**To run**:
- cd into folder
- type `vagrant up`
- select the bridge for your network (usually `eth01`)
- After installation concludes, go to `localhost:8000` or the IP address of your
  Vagrant guest at port 8000.

**To change repositories to load and install:**
- cd into `provision` folder
- edit 'gitrepos' file and add publicly available github URLs including .git
  ending.
- save file
- cd back into main folder (with Vagrantfile)

**OR**

- find the section at the end `ENTER REQUESTED PUBLIC REPOSITORIES AFTER THIS
  COMMENT GROUP`
- type `git_set` followed by the github URL of the repository (including .git)

**FOR BOTH:**

- Leave a space between the URL
- For the repository you want in the /vagrant/web folder type `WEB`
- For the repository you want in the /vagrant/docker folder type `DOCKER`
- For any other repository leave the URL with nothing following the .git, the
  repository will be stored by username and project in the `repositories` folder




