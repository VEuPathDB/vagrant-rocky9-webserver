#!/bin/bash

echo "Building site artifacts for each cohort..."

cd /home/vagrant/site_builds

echo "Genomics"
./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/api \
      ApiCommonPresenters \
      gus-site-build-deploy/config/webapp.prop \
      apisite

echo "OrthoMCL"
./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/ortho \
      OrthoMCLWebsite \
      gus-site-build-deploy/config/webapp.prop \
      orthosite

echo "ClinEpiDB"
./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/clinepi \
      ClinEpiPresenters \
      gus-site-build-deploy/config/webapp.prop \
      clinepisite

echo "MicrobiomeDB"
./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/mbio \
      MicrobiomePresenters \
      gus-site-build-deploy/config/webapp.prop \
      mbiosite
