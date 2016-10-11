# -*- mode: ruby -*-
# vi: set ft=ruby :
# SET THE IP ADDRESS AND BRIDGE SELECTION TO MATCH YOUR NETWORK
#

unless Vagrant.has_plugin?("vagrant-docker-compose")
  system("vagrant plugin install vagrant-docker-compose")
  system("vagrant plugin install vagrant-vbguest")
  puts "Dependencies installed, please try the command again."
  exit
end
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.synced_folder "./web", "/var/www", create: true, group: "www-data", owner: "www-data"
  config.vm.provision :shell, path: "./provision/setup.sh"
  config.vm.provision "shell", inline:
     "ps aux | grep 'sshd:' | awk '{print $2}' | xargs kill"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  # Assign a name to your host VM
  config.vm.hostname = "docker"
  # Use the phusion ubuntu box for our host VM
  #config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.box = "ubuntu/trusty64"
  # Run scripts to place web, docker and repo files
  config.vm.provision :shell, path: "./provision/dockerinstall.sh"
  config.vm.provision :shell, path: "./provision/public_gitrepos_to_vagrant_dir.sh"

  # Forward port 8080 to host machine
  config.vm.network "forwarded_port", guest: 80, host: 8081
  config.vm.network "forwarded_port", guest: 443, host: 8082
  config.vm.network "forwarded_port", guest: 8000, host:8000
  #network
  config.vm.network "public_network"#, ip: "192.168.0.60"

  # Sync your project in the /vagrant directory inside the VM
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision :docker
  config.vm.provision :docker_compose, yml: "/vagrant/docker/docker-compose.yml", rebuild: true, run: "always"
  config.vm.provision :shell, path: "./provision/dockerstart.sh"
  end


