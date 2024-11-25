#!/bin/bash

# copy sample conifer site vars files
cp /vagrant/sample_confs/conifer_site_vars.yml.test /home/vagrant/site_builds/site_vars/conifer_site_vars.yml.plasmo
cp /vagrant/sample_confs/conifer_site_vars.yml.qa /home/vagrant/site_builds/site_vars/conifer_site_vars.yml.qa

# copy secrets files shared by tomcat instances
sudo mkdir -p /usr/local/tomcat_instances/shared
sudo cp /vagrant/sample_confs/apidb_oauth_creds.sample /usr/local/tomcat_instances/shared/.apidb_oauth_creds
sudo cp /vagrant/sample_confs/apidb_wdk_key.sample /usr/local/tomcat_instances/shared/.apidb_wdk_key
sudo chmod -R 755 /usr/local/tomcat_instances/shared

# copy euparc
cp /vagrant/sample_confs/euparc.sample /home/vagrant/.euparc
