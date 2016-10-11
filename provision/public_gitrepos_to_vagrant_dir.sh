#!/bin/bash

# INSTRUCTIONS

# This file grabs the files from public repos and stores them in the /vagrant directory for easy access.
# Files are stored in the repositories directory on /vagrant directory
# Folders in the repositories directory are stored by username and project names in the username folder.
# Both user and project names are extracted from the github URL

# Users can also designate a docker directory or a web directory from which to place files in a special web or docker directory.
# The user does this in two ways:
# 1 - Load repos from the file store the git URL (with the .git included) in the file `gitrepos`.
#     Find `load_gitrepos_from_file` at the end of this file and be certain it is not commented out.
# OR
# 2 - Find `load_gitrepos_from_file` and comment out the line.  This will then use the defaults.
#     Change the defaults in the `default_gitrepos' function by adding the preferred git URL (with .git) preceded by the git_set function call.
#     Make sure the `default_gitrepos` function call is not commented out.

# In either case, if you wish to designate a web or docker repo, place the word WEB or DOCKER afterwards.

# Example:
# FIRST_URL.git WEB (As in the examples shown, URLs placed in defaults list must have git_set before the URL)

# Github does not allow spaces in the URL but if the user adds spaces in the URL the program will fail.
# It is also important that user keep a space between the URL and the designator.
# Designators must be all capitals and match either WEB or DOCKER exactly.

# The extraction takes the first word as URL to break into sections and the second as the designator for special actionsa

# Only one Docker or Web repo can be used at a time. If the user selects more than one, then the last repo selected in that category will be used.


# This file uses two primary functions:

# `git_grab`, which extracts the information from the URL provided with or without the designator)

#`check_replace_repo`, which checks if the folder exists.

# If the folder exists, the program will check the repo and pull the latest (master) branch from the github repo into the folder location.
# If the folder does not exist, the program will create the folder and clone the repo into the new folder location.

######### FUNCTIONS ##################################

needs_stash(){
    [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

git_set () {
  fullurl=$1
  case $2 in
    "WEB") designate="WEB"
    echo "WEB set by DEFAULT LIST from $fullurl";;
    "DOCKER") designate="DOCKER"
    echo "DOCKER set by DEFAULT LIST from  $fullurl";;
    "*") $designate = "" ;;
  esac
}

git_grab(){
    echo "Attempting to download repo from $fullurl"
    echo
    url=$fullurl

    url_without_suffix="${url%.*}"
    echo "From git url: $url_without_suffix"
    reponame="$(basename "${url_without_suffix}")"
    echo "Project folder: $reponame"
    hostname="$(basename "${url_without_suffix%/${reponame}}")"
    echo "User folder: $hostname"
#    DIR=i./vagrant/repositories/`basename $1 .git`
    echo "Installing repo from:$url_without_suffix now to folder:$reponame in folder:$hostname in /vagrant/repositories"

    # Set install directory for repo files in repositories folder in /vagrant directory.
    # If git repo url is followed by either WEB or DOCKER then:
    # On case WEB - place files in web folder in /vagrant directory
    # On case DOCKER - place files in docker folder in /vagrant/directory
    # Otherwise user repositories folder to store files by repo name in the folder of the github username

    case $designate in
    #Case WEB - to /vagrant/web folder
    "WEB")
      echo "Set or replace contents of /vagrant/web folder with $fullurl"
      sudo rm -r /vagrant/web/
      DIR=/vagrant/web/
      check_replace_repo $DIR

      # To prevent errors when multiple repos are copied to the same folders, the www and dockerfiles are wiped on selection of a WEB or DELETE designator in the git_grab function

      ;;

    #Case DOCKER -  to /vagrant/docker folder
    # Needs docker-compose to function
    "DOCKER")
      echo "Set or replace contents of /vagrant/docker folder with $fullurl"
      sudo rm -r /vagrant/docker/
      DIR=/vagrant/docker/

      # I kept the check here because I plan to make the collection of git repos for docker & web to be an option not automated later
      check_replace_repo $DIR
            ;;

    # Normal Repo
    *)
      echo "Placing repo in repositories folder by username by project"
      DIR=/vagrant/repositories/$hostname/$reponame
      check_replace_repo $DIR
      ;;
    esac

}

check_replace_repo(){

    # Check if the repo folder exists, if not clone it. If so, do a git pull in the folder to assure newest commits are in the folders stored in the vagrant instance.

    echo $url
    echo "Place in this directory --> $DIR"
    if [ ! -d $DIR ]; then
    echo "Placing Files HERE: $url $DIR"
    git clone $url $DIR
    else
      # "Directory exists so do git pull to get latest commits"
      pushd $DIR
      if needs_stash; then
        # "Do git stash"
        git stash
        # "Do git pull"
        git pull --quiet
        git stash pop
      else
        # "No stash needed, just git pull"
        git init
        remote_addr=(git remote -v)
        # "Easier to reset remote address here"
        git remote set-url origin $url
        git pull origin master --quiet
      fi
      echo "Finished with checks, files are placed or updated."
      popd
    fi
}

git_test () {
    # Check if it is in the proper format for a github repository URL
    # Also identify if the designator for the URL to set the repo to the WEB or DOCKER folder exists
    # Otherwise install to the normal location of /vagrant/repositories

    IFS='.' read -a URL <<< "${WORDS[1]}"
    IFS=" " read -a FILEFLAG <<< "${URL[2]}"

    httpcheck=${FILEFLAG[0]}
    httpcheck2="git"

    shopt -s nocasematch
    case "$httpcheck" in
      $httpcheck2)
          designate="${FILEFLAG[1]}"
          IFS=" " read -a URLONLY <<< $p
          fullurl=${URLONLY[0]}
          git_grab $fullurl
      echo;;
    *)
      echo "Not a working git URL"
      echo "Does not end in git" ;;
    esac

  }

is_website () {
   IFS=':' read -a WORDS <<< "$p"
   # Does it at least start with http?
   httpcheck=${WORDS[0]:0:4}
   httpcheck2="http"
   shopt -s nocasematch
   case "$httpcheck" in
     $httpcheck2)
       git_test "${WORDS[1]}" ;;
     *)
          echo "INVALID SITE OR FORMAT: $p is either:"
          echo "1. Not a website"
          echo "2. Starts with something in front of the URL"
          echo "3. Is missing the http:// part of the URL the program needs to run correctly."
          echo "Please correct $p in the gitrepos file"
          echo ;;
    esac
 }

load_gitrepos_from_file () {
# THIS FUNCTION LOADS THE GITREPOS FROM THE `gitrepos` FILE IN THE PROVISION FOLDER
  filename='/vagrant/provision/gitrepos'
  exec 4<$filename
  while read -u4 p ; do
    if [ ! -z "$p" ];
    then
      if [[ ! ${p:0:1} == "#" ]]  # Remove comments
      then
        is_website $p
      fi
    else
      echo
      echo "This line '#$p' is blank"
      echo
    fi
     done
 }

default_gitrepos () {
# THIS FUNCTION LOADS THE DEFAULT GITREPOS FROM THE LIST BELOW
# ADD REPOSITORIES HERE TO CHANGE DEFAULTS
# USE WEB OR DOCKER DESIGNATOR AFTER TO NOTIFY TO SET AS WEB OR DOCKER REPO FOR VAGRANT TO USE

#Enter information for public repos in the following format:
# git_set github_url
# Follow with WEB or DOCKER to designate that repo for either the web or docker folder.
# WEB for files you wish to make available to display, these will be stored in the /vagrant/web directory
# DOCKER for the docker files including docker-compose that will build the docker instance which will be stored in the /vagrant/docker directory


  git_set https://github.com/twistedgitbox/TestforChanges.git
  #
  git_set https://github.com/puppetlabs/exercise-webpage.git WEB
  #
  git_set https://github.com/twistedgitbox/simple_nginx.git DOCKER
  #
# EXAMPLE:

# git_set https://github.com/twistedgitbox/TestforChanges.git
#
# git_set https://github.com/puppetlabs/exercise-webpage.git WEB
#
# git_set https://github.com/twistedgitbox/simple_nginx.git DOCKER


# NOTE: Private repos will need additional code to deal with the SSL requirements

}

############# PROGRAM START #############

# COMMENT OUT `default_gitrepos` TO KEEP PROGRAM FROM LOADING DEFAULTS
default_gitrepos # Use defaults in loading git repositories
# COMMENT OUT load_gitrepos_from_file TO KEEP PROGRAM FROM LOADING REPOSITORIES FROM FILE
# The `gitrepos` file is located in the provision folder.
load_gitrepos_from_file

echo "Please use find the IP address of the vagrant instance using ifconfig. I have set it to 192.168.0.60."
echo "Access the website at port 8000 using localhost:8000 or vagrant guest IP_address:8000"








