#!/bin/bash
if [[ $EUID > 0 ]]; then
  echo "Please run as root"
  exit
fi

linkSample() {

  sampleFile=$1
  confFile=$2
  linkLocation=$3

  if [ -e /vagrant/conf/$confFile ]; then
    echo "File conf/$confFile already exists.  Skipping."
  else
    echo "Copying conf_samples/$sampleFile to conf/$confFile"
    cp /vagrant/conf_samples/$sampleFile /vagrant/conf/$confFile
  fi

  if [ "$linkLocation" == "" ]; then
    echo "No link requested for conf/$confFile"
  else
    if [ -e $linkLocation ]; then
      echo "Link $linkLocation already exists.  Skipping."
    else
      echo "Creating link $linkLocation to conf/$confFile"
      sudo ln -s /vagrant/conf/$confFile $linkLocation
    fi
  fi
  echo
}

echo

linkSample apidb_oauth_creds.sample   apidb_oauth_creds            /usr/local/tomcat_instances/shared/.apidb_oauth_creds
linkSample apidb_wdk_key.sample       apidb_wdk_key                /usr/local/tomcat_instances/shared/.apidb_wdk_key
linkSample euparc.sample              euparc                       /home/vagrant/.euparc
linkSample ssh_config                 ssh_config                   /home/vagrant/.ssh/config
linkSample bashrc_addons.sample       bashrc_addons
linkSample conifer_site_vars.yml.qa   conifer_site_vars.yml.qa
linkSample conifer_site_vars.yml.test conifer_site_vars.yml.plasmo
linkSample conifer_site_vars.yml.test conifer_site_vars.yml.ortho
linkSample conifer_site_vars.yml.test conifer_site_vars.yml.clinepi
linkSample conifer_site_vars.yml.test conifer_site_vars.yml.mbio

if [ "$(grep bashrc_addons /home/vagrant/.bashrc | wc -l)" -gt "0" ]; then
  echo "Bash Add-Ons already added to /home/vagrant/.bashrc.  Skipping."
else
  echo "Adding Bash Add-Ons to /home/vagrant/.bashrc"
  printf "\n\nsource /vagrant/conf/bashrc_addons\n\n" >> /home/vagrant/.bashrc
fi
