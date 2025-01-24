#!/bin/bash

echo "Unpacking and configuring site artifacts for each cohort..."

cd /home/vagrant/site_builds

./gus-site-build-deploy/bin/veupath-unpack-and-configure.sh \
    /home/vagrant/site_builds/build/api/apisite.tar.gz \
    /var/www/test.plasmodb.org \
    /vagrant/conf/conifer_site_vars.yml.plasmo

./gus-site-build-deploy/bin/veupath-unpack-and-configure.sh \
    /home/vagrant/site_builds/build/api/apisite.tar.gz \
    /var/www/q2.plasmodb.org \
    /vagrant/conf/conifer_site_vars.yml.qa

./gus-site-build-deploy/bin/veupath-unpack-and-configure.sh \
    /home/vagrant/site_builds/build/ortho/orthosite.tar.gz \
    /var/www/test.orthomcl.org \
    /vagrant/conf/conifer_site_vars.yml.ortho

./gus-site-build-deploy/bin/veupath-unpack-and-configure.sh \
    /home/vagrant/site_builds/build/clinepi/clinepisite.tar.gz \
    /var/www/test.clinepidb.org \
    /vagrant/conf/conifer_site_vars.yml.clinepi

./gus-site-build-deploy/bin/veupath-unpack-and-configure.sh \
    /home/vagrant/site_builds/build/mbio/mbiosite.tar.gz \
    /var/www/test.microbiomedb.org \
    /vagrant/conf/conifer_site_vars.yml.mbio
