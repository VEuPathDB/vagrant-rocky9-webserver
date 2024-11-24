#!/bin/bash

if [ "$NON_GUS_PATH" == "" ]; then
    export NON_GUS_PATH=$PATH
fi

setsite() {
    siteDomain=$1
    export GUS_HOME=/var/www/$siteDomain/gus_home
    export PROJECT_HOME=/var/www/$siteDomain/project_home
    export PATH=$GUS_HOME/bin:$PROJECT_HOME/install/bin:$NON_GUS_PATH
}

setsite test.plasmodb.org
