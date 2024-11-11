# Vagrant Setup for Running VEuPathDB sites on Rocky 9 VM
Testbed for building websites on Rocky 8 with Java 21 and Tomcat 9

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
**Note**: you might have to enable virtualization in your BIOS.  (You might get an error hinting at that.)

4. This may result in a time out at "SSH auth method: private key".  To fix:

    - Run "vagrant halt", which will shut down the attempted boot
    - Bring up VirtualBox
    - Right click on your VM and select Settings...
    - Select "System"
    - Check the checkbox next to "Enable EFI" and click OK
    - Run "vagrant up" again

5. Right now there are unresolved issues around the /vagrant mount; Fixes TBD.  Update: Seems to be fixed in Rocky 9 box.

6. SSH into the box
<pre>
> vagrant ssh
</pre>

7. Resize installation partition if necessary.  Vagrantfile specifies 25gb but the created partitions may not use it all.  To expand to use the entire disk, try:
<pre>
> sudo fdisk -l
      (may show sda5 only using 10gb or less; should be ~25gb)
> sudo parted /dev/sda
(parted) resizepart 5 100%
Warning: Partition /dev/sda5 is being used. Are you sure you want to continue?
Yes/No? Yes
(parted) quit
> sudo fdisk -l
      (should now show full usage of 25gb in /dev/sda5)
> sudo xfs_growfs /dev/sda5
</pre>

8. Install system packages
<pre>
> sudo bash /vagrant/system_installs.sh
-OR-
> sudo bash ./system_installs.sh (copy/pasted file if mount does not work)
</pre>

9. Log out and back in again to get a clean shell, this time with your local SSH keys
<pre>
> exit
> vagrant ssh -- -A
</pre>

10. Add your github credentials to ~/.bashrc and source it
<pre>
export GITHUB_USERNAME=#####
export GITHUB_TOKEN=#####
</pre>

11. Create a website build framework and build initial tarballs of all four cohorts
<pre>
> bash /vagrant/build_installs.sh
-OR-
> bash ./build_installs.sh (copy/pasted file if mount does not work)
</pre>

12. Build out directory structure for sites and create test sites for each cohort (TODO: use tomcat_instance_framework here)
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

13. Create conifer configuration dependencies

You will need different conifer_site_vars.yml files for each cohort site.  To start out, copy a conifer_site_vars.yml file from a genomics dev site on palm into `/home/vagrant/site_builds/site_vars/conifer_site_vars.yml.plasmo`.

14. Unpack and configure sites

Try to deploy the genomics site by running the command:
<pre>
> ./gus-site-build-deploy/bin/veupath-unpack-and-configure.sh ~/site_builds/build/api/ApiCommonPresenters_*.tar.gz /var/www/test.plasmodb.org site_vars/conifer_site_vars.yml.plasmo
</pre>

Currently this step is failing on a conifer error due to the new python+ansible setup in Rocky 9.  This needs to be fixed up!

15. When finished testing your local website, destroy the VM with
<pre>
> vagrant destroy -f
</pre>

