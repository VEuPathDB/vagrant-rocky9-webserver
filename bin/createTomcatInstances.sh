#!/bin/bash

cd /usr/local/tomcat_instances

makeInstance() {
  projectId=$1
  portSegment=$2
  sudo make install \
    INSTANCE=$projectId \
    HTTP_PORT=190${portSegment}0 \
    AJP13_PORT=190${portSegment}9 \
    JMX_PORT=190${portSegment}5 \
    TOMCAT_USER=vagrant \
    ORCL_JDBC_PATH=/usr/local/tomcat_instances/shared/ojdbc11.jar \
    TEMPLATE=9.0.x \
    CATALINA_HOME=/usr/local/tomcat-9
  sudo mkdir /var/www/$projectId
}

portSegment=1
for projectId in "PlasmoDB" "OrthoMCL" "MicrobiomeDB" "ClinEpiDB"; do
  echo "Creating Tomcat instance for $projectId with port segment $portSegment"
  makeInstance $projectId $portSegment
  portSegment=$((portSegment+1))
done
