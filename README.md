# vagrant-rocky8-webserver
Testbed for building websites on Rocky 8 with Java 21 and Tomcat 10

1. Install VirtualBox and Vagrant on your host machine (laptop)

2. Install plugin for local disk mounting
<pre>
> sudo apt-get install virtualbox
> sudo apt-get install virtualbox-guest-additions-iso
> sudo apt-get install vagrant
> vagrant plugin install vagrant-vbguest
</pre>
If vagrant install doesn't work, follow instructions here: https://developer.hashicorp.com/vagrant/install

3. Clone this repo and create the VM
<pre>
> git clone git@github.com:VEuPathDB/vagrant-rocky8-webserver.git
> cd vagrant-rocky8-webserver
> vagrant up
</pre>
4. This may result in a time out at "SSH auth method: private key".  To fix:

    - Run "vagrant halt", which will shut down the attempted boot
    - Bring up VirtualBox
    - Right click on your VM and select Settings...
    - Select "System"
    - Check the checkbox next to "Enable EFI" and click OK
    - Run "vagrant up" again

5. Right now there are unresolved issues around the /vagrant mount; Fixes TBD

6. SSH into the box
<pre>
> vagrant ssh
</pre>
7. Resize installation partition if necessary.  Vagrantfile specifies 25gb but the created partitions may not use it all.  To expand to use the entire disk, try:
<pre>
> sudo fdisk -l
      (may show sda4 only using 10gb; should be 25gb)
> sudo parted /dev/sda
(parted) resizepart 4 100%
Warning: Partition /dev/sda4 is being used. Are you sure you want to continue?
Yes/No? Yes
(parted) quit
> sudo fdisk -l
      (should now show full usage of 25gb in /dev/sda4)
> sudo xfs_growfs /dev/sda4
</pre>
8. Install system packages.  Copy (cut/paste since mount does not work) the system_installs.sh script into /home/vagrant and run it as sudo
<pre>
> sudo bash ./system_installs.sh
</pre>
9. Log out and back in again to get a clean shell, this time with your local SSH keys
<pre>
> exit
> vagrant ssh -- -A
</pre>
10. Install user packages.  Copy the user_installs.sh script into /home/vagrant and run it
<pre>
> bash ./user_installs.sh
</pre>
11. Add your github credentials to ~/.bashrc and source it
<pre>
export GITHUB_USERNAME=#####
export GITHUB_TOKEN=#####
</pre>
12. Create a website build framework
<pre>
> mkdir -p build/api build/clinepi build/mbio build/ortho project_home site_vars
> git clone git@github.com:VEuPathDB/gus-site-build-deploy.git
> cd project_home
> tsrc init git@github.com:VEuPathDB/tsrc.git --group websiteRelease
> cd -
</pre>
13. Build site artifacts for each cohort
<pre>
> ./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/api \
      ApiCommonPresenters \
      gus-site-build-deploy/config/webapp.prop
> ./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/ortho \
      OrthoMCLWebsite \
      gus-site-build-deploy/config/webapp.prop
> ./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/clinepi \
      ClinEpiPresenters \
      gus-site-build-deploy/config/webapp.prop
> ./gus-site-build-deploy/bin/veupath-package-website.sh \
      project_home \
      build/mbio \
      MicrobiomePresenters \
      gus-site-build-deploy/config/webapp.prop
</pre>
14. Build out directory structure for sites and create test sites for each cohort (TODO: use tomcat_instance_framework here)
<pre>
> sudo mkdir -p /var/www
> cd /var/www
> sudo mkdir -p PlasmoDB/plasmo.test OrthoMCL/orthomcl.test ClinEpiDB/ce.test MicrobiomeDB/mbio.test
> sudo chmod 777 */*
> sudo ln -s PlasmoDB/plasmo.test test.plasmodb.org
> sudo ln -s OrthoMCL/orthomcl.test test.orthomcl.org
> sudo ln -s ClinEpiDB/ce.test test.clinepidb.org
> sudo ln -s MicrobiomeDB/mbio.test test.microbiomedb.org
</pre>
16. Create conifer configuration dependencies


17. Unpack and configure sites


Lots more stuff to do here!  Next step: deployment!



14. When finished testing your local website, destroy the VM with
<pre>
> vagrant destroy -f
</pre>

