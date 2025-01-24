#!/bin/bash

bash /vagrant/bin/3.1-setUpSiteBuilds.sh
bash /vagrant/bin/3.2-buildSiteArtifacts.sh
bash /vagrant/bin/3.3-unpackAndConfigureSites.sh
