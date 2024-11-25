#!/bin/bash

sites=(
    "PlasmoDB/plasmo.test:test.plasmodb.org"
    "PlasmoDB/plasmo.b69:q2.plasmodb.org"
    "OrthoMCL/orthomcl.test:test.orthomcl.org"
    "ClinEpiDB/ce.test:test.clinepidb.org"
    "MicrobiomeDB/mbio.test:test.microbiomedb.org"
)

mkdir -p /var/www
cd /var/www

# loop through sites defined above
for site in ${sites[@]}; do

    # pick out data for this site
    dataArray=( $(echo $site | sed 's/:/ /g') )
    tomcatDir=${dataArray[0]}
    domainLink=${dataArray[1]}

    # create domain soft link to tomcat instance webapp dir
    mkdir -p $tomcatDir
    chmod -R 777 $tomcatDir/..
    ln -s $tomcatDir $domainLink

    # make soft link to project_home (eases reruns of conifer, if needed)
    cd $domainLink
    ln -s ~/site_builds/project_home
    cd -

done
