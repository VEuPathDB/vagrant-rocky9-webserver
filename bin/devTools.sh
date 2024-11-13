#!/bin/bash

export PROJECT_HOME=/home/vagrant/site_builds/project_home

if [ "$NON_GUS_PATH" == "" ]; then
    export NON_GUS_PATH=$PROJECT_HOME/install/bin:$PATH
fi

setsite() {
    siteDomain=$1
    export GUS_HOME=/var/www/$siteDomain/gus_home
    export PATH=$GUS_HOME/bin:$NON_GUS_PATH
}

setsite test.plasmodb.org
