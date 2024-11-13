#!/bin/bash

mkdir -p /var/www
cd /var/www
mkdir -p PlasmoDB/plasmo.test OrthoMCL/orthomcl.test ClinEpiDB/ce.test MicrobiomeDB/mbio.test
chmod 777 */*
ln -s PlasmoDB/plasmo.test test.plasmodb.org
ln -s OrthoMCL/orthomcl.test test.orthomcl.org
ln -s ClinEpiDB/ce.test test.clinepidb.org
ln -s MicrobiomeDB/mbio.test test.microbiomedb.org
