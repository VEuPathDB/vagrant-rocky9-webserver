#!/bin/bash
if [[ $EUID > 0 ]]; then
  echo "Please run as root"
  exit
fi

bash /vagrant/bin/2.1-fixDiskPartitionSize.sh
bash /vagrant/bin/2.2-installTomcat.sh
bash /vagrant/bin/2.3-linkSampleConfigs.sh
bash /vagrant/bin/2.4-createTomcatInstances.sh
bash /vagrant/bin/2.5-buildSiteDeploymentDirs.sh
