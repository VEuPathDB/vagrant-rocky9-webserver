#!/bin/sh

# basic build tools
sudo dnf install -y wget emacs gcc gcc-c++ git ant maven php

# Java
sudo dnf install -y java-21-openjdk java-21-openjdk-devel
javadir=/usr/lib/jvm/java-21-openjdk-21.0.3.0.9-1.el8.x86_64
printf "export JAVA_HOME=${javadir}\nexport PATH=\$JAVA_HOME/bin:\$PATH" > java.sh && sudo mv java.sh /etc/profile.d
source /etc/profile.d/java.sh    # or log in again

# perl and related dependencies
sudo dnf -y install perl expat-devel
echo 'yes' | cpan
sudo cpan install XML::Simple
sudo cpan install XML::Parser
sudo cpan install XML::Twig
sudo cpan install IO::String # JBrowse dep

# python 2/3 and related modules
#   TODO: python3 default Python 3.6 is no longer officially supported!  Figure this out with 3.11.
sudo dnf config-manager --set-enabled powertools
sudo dnf install -y python3 epel-release python3-pip python3-wheel
sudo alternatives --set python /usr/bin/python3
sudo pip3 install --trusted-host pypi.org --upgrade pip
sudo pip3 install --trusted-host pypi.org --upgrade setuptools
sudo dnf install -y python2

# conifer dependencies
sudo pip3 install --trusted-host pypi.org six
sudo pip3 install --trusted-host pypi.org pyyaml
sudo pip3 install --trusted-host pypi.org setuptools-rust
sudo pip3 install --trusted-host pypi.org ansible

# tsrc
sudo pip3 install --trusted-host pypi.org tsrc

# helper function to verify checksums
verify() {
  if [[ "$(sha512sum $3 | awk '{print $1}')" != "$(cat $2 | awk '{print $1}')" ]]; then
    echo "$1 checksum verification failed"
    exit 1
  fi
}

# Tomcat 10
#   TODO: convert to RPM
cd /usr/local
tomcat_version=10.1.23
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz
sudo wget https://downloads.apache.org/tomcat/tomcat-10/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz.sha512
verify tomcat apache-tomcat-${tomcat_version}.tar.gz.sha512 /usr/local/apache-tomcat-${tomcat_version}.tar.gz
sudo rm apache-tomcat-${tomcat_version}.tar.gz.sha512
sudo tar zxvf apache-tomcat-${tomcat_version}.tar.gz
sudo rm -f apache-tomcat-${tomcat_version}.tar.gz
sudo ln -s apache-tomcat-${tomcat_version} tomcat
cd -
