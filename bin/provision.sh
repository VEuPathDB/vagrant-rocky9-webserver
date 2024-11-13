#!/bin/sh

# update system to latest
sudo dnf update -y

# basic build tools
sudo dnf install -y epel-release wget emacs gcc gcc-c++ git ant maven php nodejs ansible-core

# Java
sudo dnf install -y java-21-openjdk java-21-openjdk-devel
sudo alternatives --set java java-21-openjdk.x86_64
sudo alternatives --set javac java-21-openjdk.x86_64
sudo alternatives --set jre_openjdk java-21-openjdk.x86_64
sudo alternatives --set java_sdk_openjdk java-21-openjdk.x86_64

# configure java for user profiles
printf "export JAVA_HOME=/usr/lib/jvm/java PATH=\$JAVA_HOME/bin:\$PATH" > java.sh && sudo mv java.sh /etc/profile.d
source /etc/profile.d/java.sh    # or log in again

# perl and related dependencies
sudo dnf -y install perl expat-devel # perl-XML-Simple
echo 'yes' | sudo cpan
sudo cpan install XML::Simple
sudo cpan install XML::Parser
sudo cpan install XML::Twig
sudo cpan install IO::String # JBrowse dep

#sudo dnf config-manager --set-enabled powertools
sudo dnf install -y python3 python3-pip
#epel-release python3-pip python3-wheel
#sudo alternatives --set python /usr/bin/python3
#sudo pip3 install --trusted-host pypi.org --upgrade pip
#sudo pip3 install --trusted-host pypi.org --upgrade setuptools
#sudo dnf install -y python2

# conifer dependencies
#sudo pip3 install --trusted-host pypi.org six
#sudo pip3 install --trusted-host pypi.org pyyaml
#sudo pip3 install --trusted-host pypi.org setuptools-rust
#sudo pip3 install ansible

# tsrc
sudo pip3 install tsrc

# python 2 and related modules (attempt 2)
#sudo dnf config-manager --set-enabled powertools
#sudo dnf install -y python2
#sudo alternatives --set python /usr/bin/python2
#sudo pip2 install --upgrade pip
#sudo pip2 install --upgrade setuptools
#sudo pip2 install six
#sudo pip2 install pyyaml
#sudo pip2 install setuptools-rust
#sudo pip2 install ansible

# python 3
#sudo dnf install -y python3
#sudo pip3 install --trusted-host pypi.org --upgrade pip
#sudo pip3 install --trusted-host pypi.org --upgrade setuptools
#sudo pip3 install tsrc

# helper function to verify checksums
#verify() {
#  if [[ "$(sha512sum $3 | awk '{print $1}')" != "$(cat $2 | awk '{print $1}')" ]]; then
#    echo "$1 checksum verification failed"
#    exit 1
#  fi
#}

# Tomcat 9
cd /usr/local
tomcat_version=9.0.97
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz
sudo tar zxvf apache-tomcat-${tomcat_version}.tar.gz
sudo rm -f apache-tomcat-${tomcat_version}.tar.gz
sudo ln -s apache-tomcat-${tomcat_version} tomcat
cd -

# Tomcat 10
#   TODO: convert to RPM
#cd /usr/local
#tomcat_version=10.1.23
#sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz
#sudo wget https://downloads.apache.org/tomcat/tomcat-10/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz.sha512
#verify tomcat apache-tomcat-${tomcat_version}.tar.gz.sha512 /usr/local/apache-tomcat-${tomcat_version}.tar.gz
#sudo rm apache-tomcat-${tomcat_version}.tar.gz.sha512
#sudo tar zxvf apache-tomcat-${tomcat_version}.tar.gz
#sudo rm -f apache-tomcat-${tomcat_version}.tar.gz
#sudo ln -s apache-tomcat-${tomcat_version} tomcat
#cd -
