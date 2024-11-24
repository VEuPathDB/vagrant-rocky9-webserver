#!/bin/sh

# update system to latest (9.5 as of this writing)
sudo dnf update -y
sudo dnf upgrade -y

# basic build/dev tools
sudo dnf install -y epel-release wget emacs gcc gcc-c++ git

# java and related tools
sudo dnf install -y java-21-openjdk java-21-openjdk-devel ant maven
sudo alternatives --set java java-21-openjdk.x86_64
sudo alternatives --set javac java-21-openjdk.x86_64
sudo alternatives --set jre_openjdk java-21-openjdk.x86_64
sudo alternatives --set java_sdk_openjdk java-21-openjdk.x86_64

# configure java for user profiles
printf "export JAVA_HOME=/usr/lib/jvm/java PATH=\$JAVA_HOME/bin:\$PATH" > java.sh && sudo mv java.sh /etc/profile.d
source /etc/profile.d/java.sh    # or log in again

# perl and required modules
sudo dnf install -y perl expat-devel # perl-XML-Simple
echo 'yes' | sudo cpan
sudo cpan install XML::Simple
sudo cpan install XML::Parser
sudo cpan install XML::Twig
sudo cpan install IO::String # JBrowse dep

# python and ansible
sudo dnf install -y python3 python3-pip ansible-core

# misc dev tools
sudo dnf install -y php nodejs

# tsrc
sudo pip3 install tsrc

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
