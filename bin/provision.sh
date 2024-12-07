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
sudo dnf install -y perl expat-devel perl-XML-Simple
echo 'yes' | sudo cpan
sudo cpan install XML::Twig
#sudo cpan install IO::String # JBrowse dep

# python and ansible
sudo dnf install -y python3 python3-pip ansible-core

# misc dev tools
sudo dnf install -y php nodejs

# tsrc
sudo pip3 install tsrc

# install Tomcat 9, 10, and 11 from built RPMs
rpmBuilderRelease="20241206"
tomcatVersions=( "9.0.97" "10.1.33" "11.0.1" )
for version in ${tomcatVersions[@]}; do
  tomcatRpm="tomcat-$version-ebrc-1.x86_64.rpm"
  wget "https://github.com/VEuPathDB/tool-tomcat-rpm-builder/releases/download/$rpmBuilderRelease/$tomcatRpm"
  sudo rpm -i $tomcatRpm
  rm $tomcatRpm
done

# install Tomcat Instance Framework from release RPM
tcifRpm=tomcat-instance-framework-2.2.0-1.el.x86_64.rpm
wget https://github.com/VEuPathDB/tomcat-instance-framework/releases/download/2.2.0/$tcifRpm
sudo rpm -i $tcifRpm
rm $tcifRpm
