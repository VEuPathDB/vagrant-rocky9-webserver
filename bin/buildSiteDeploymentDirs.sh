#!/bin/bash

sites=(
    "PlasmoDB:plasmo.test:test.plasmodb.org"
    "PlasmoDB:plasmo.b69:q2.plasmodb.org"
    "OrthoMCL:orthomcl.test:test.orthomcl.org"
    "ClinEpiDB:ce.test:test.clinepidb.org"
    "MicrobiomeDB:mbio.test:test.microbiomedb.org"
)

topDir=/var/www

# loop through sites defined above
for site in ${sites[@]}; do

    # pick out data for this site
    dataArray=( $(echo $site | sed 's/:/ /g') )
    instance=${dataArray[0]}
    webapp=${dataArray[1]}
    domain=${dataArray[2]}

    echo "Will create site $domain in $topDir/$instance as webapp $webapp"

    # create domain soft link to tomcat instance webapp dir
    sudo chmod 777 $topDir/$instance
    mkdir $topDir/$instance/$webapp
    sudo chmod 755 $topDir/$instance
    sudo ln -s $topDir/$instance/$webapp $topDir/$domain

done
