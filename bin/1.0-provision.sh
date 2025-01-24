#!/bin/sh

# update system to latest (9.5 as of this writing)
sudo dnf update -y
sudo dnf upgrade -y

# basic build/dev tools
sudo dnf install -y epel-release wget emacs gcc gcc-c++ git rpm-build

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
pip3 install tsrc
