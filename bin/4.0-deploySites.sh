#!/bin/bash

echo "Deploying webapps..."

instance_manager manage PlasmoDB deploy /var/www/test.plasmodb.org/gus_home/config/plasmo.test.xml
# QA site will fail because of Oracle OCI driver connection URL (not supported); once fixed, deploy with other webapps
#instance_manager manage PlasmoDB deploy /var/www/q2.plasmodb.org/gus_home/config/plasmo.b69.xml
instance_manager manage OrthoMCL deploy /var/www/test.orthomcl.org/gus_home/config/orthomcl.test.xml
instance_manager manage ClinEpiDB deploy /var/www/test.clinepidb.org/gus_home/config/ce.test.xml
instance_manager manage MicrobiomeDB deploy /var/www/test.microbiomedb.org/gus_home/config/mbio.test.xml