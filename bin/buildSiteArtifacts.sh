#!/bin/bash

echo "Building out build directories"
cd ~
mkdir -p site_builds
cd site_builds
mkdir -p build/api build/clinepi build/mbio build/ortho project_home site_vars

echo "Cloning gus-site-build-deploy if necessary"
if [ ! -e gus-site-build-deploy ]; then
  git clone git@github.com:VEuPathDB/gus-site-build-deploy.git
fi

echo "Cloning GUS projects for website builds"
cd project_home
if [ ! -e .tsrc ]; then
  tsrc init git@github.com:VEuPathDB/tsrc.git --group websiteRelease  
fi

# Temporary(?) hack; do not install JBrowse for node/python issues in Rocky9
cd ApiCommonWebsite
git checkout no-jbrowse
cd ..

# Need special conifer branch for python3 + ansible8
cd conifer
git checkout rhel-9
cd ..

# Use Java 21 / Tomcat 9 brances of the following projects
for project in "EbrcWebsiteCommon" "FgpUtil" "MicrobiomeWebsite" "OAuth2Server" "WDK" "install"; do
  cd $project
  git checkout j21tc9
  cd ..
done

# back up out of project_home
cd ..

echo "Building site artifacts for each cohort..."

echo "Genomics"
./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/api \
      ApiCommonPresenters \
      gus-site-build-deploy/config/webapp.prop
echo "OrthoMCL"
./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/ortho \
      OrthoMCLWebsite \
      gus-site-build-deploy/config/webapp.prop
echo "ClinEpiDB"
./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/clinepi \
      ClinEpiPresenters \
      gus-site-build-deploy/config/webapp.prop
echo "MicrobiomeDB"
./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/mbio \
      MicrobiomePresenters \
      gus-site-build-deploy/config/webapp.prop
