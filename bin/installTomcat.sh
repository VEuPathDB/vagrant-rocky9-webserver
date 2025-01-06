#!/bin/bash

# install Tomcat 9, 10, and 11 from built RPMs
rpmBuilderRelease="20250105"
tomcatVersions=( "9.0.98" "10.1.34" "11.0.2" )
for fullVersion in ${tomcatVersions[@]}; do
  majorVersion=$(echo "$fullVersion" | sed -e 's/\([0-9]*\).*/\1/')
  tomcatRpm="tomcat-${majorVersion}-${fullVersion}-1.x86_64.rpm"
  wget "https://github.com/VEuPathDB/tool-tomcat-rpm-builder/releases/download/$rpmBuilderRelease/$tomcatRpm"
  sudo rpm -i $tomcatRpm
  rm $tomcatRpm
done

# install Tomcat Instance Framework from release RPM
tcifVersion=2.5.1
tcifRpm=tomcat-instance-framework-$tcifVersion-1.el9.x86_64.rpm
wget https://github.com/VEuPathDB/tomcat-instance-framework/releases/download/$tcifVersion/$tcifRpm
sudo rpm -i $tcifRpm
rm $tcifRpm

# in lieu of a full Oracle installation, simply download the thin driver jar
$(cd /usr/local/tomcat_instances/shared && sudo wget https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc11/23.6.0.24.10/ojdbc11-23.6.0.24.10.jar -O ojdbc11.jar)
