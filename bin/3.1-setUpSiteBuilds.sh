#!/bin/bash

cd /home/vagrant

echo "Building out build directories"
mkdir -p site_builds
cd site_builds
mkdir -p build/api build/clinepi build/mbio build/ortho project_home

echo "Cloning gus-site-build-deploy if necessary"
if [ ! -e gus-site-build-deploy ]; then
  git clone git@github.com:VEuPathDB/gus-site-build-deploy.git
fi

echo "Cloning GUS projects for website builds"
cd project_home
if [ ! -e .tsrc ]; then
  tsrc init git@github.com:VEuPathDB/tsrc.git --group websiteRelease  
fi

# Need special conifer branch for python3 + ansible8
cd conifer
git checkout rhel-9
cd ..

# Use Java 21 / Tomcat 9 branches of the following projects
#  NOTE: the branch in ApiCommonWebsite removes JBrowse from the build due to node/python issues in Rocky 9
for project in "ApiCommonWebsite" "ClinEpiWebsite" "EbrcWebsiteCommon" "FgpUtil" "MicrobiomeWebsite" "OAuth2Server" "OrthoMCLService" "WDK" "install"; do
  cd $project
  git checkout j21tc9
  cd ..
done
