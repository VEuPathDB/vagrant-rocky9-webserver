#!/bin/bash
if [[ $EUID > 0 ]]; then
  echo "Please run as root"
  exit
fi

###################################
## Requires sudo
###################################

sites=(
    "PlasmoDB:plasmo.test:test.plasmodb.org"
    "PlasmoDB:plasmo.b69:q2.plasmodb.org"
    "OrthoMCL:orthomcl.test:test.orthomcl.org"
    "ClinEpiDB:ce.test:test.clinepidb.org"
    "MicrobiomeDB:mbio.test:test.microbiomedb.org"
)

topDir=/var/www

mkdir -p $topDir/Common/tmp/wdkStepAnalysisJobs
chmod -R 777 $topDir/Common

# loop through sites defined above
for site in ${sites[@]}; do

    # pick out data for this site
    dataArray=( $(echo $site | sed 's/:/ /g') )
    instance=${dataArray[0]}
    webapp=${dataArray[1]}
    domain=${dataArray[2]}

    echo "Will create site $domain in $topDir/$instance as webapp $webapp"

    # create domain soft link to tomcat instance webapp dir
    chmod 755 $topDir/$instance
    mkdir -p $topDir/$instance/$webapp
    chown vagrant $topDir/$instance/$webapp
    chgrp vagrant $topDir/$instance/$webapp
    if [ ! -e $topDir/$domain ]; then
      ln -s $topDir/$instance/$webapp $topDir/$domain
    fi
done
