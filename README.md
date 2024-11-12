# Vagrant Setup for Running VEuPathDB sites on Rocky 9 VM
Testbed for building websites on Rocky 8 with Java 21 and Tomcat 9

1. Install VirtualBox and Vagrant on your host machine (laptop).
  
Depending on your Linux distribution, you may be able to use native packaging, or will need to follow the vendor instructions.  Examples:

### Native Packaging
<pre>
> sudo apt-get install virtualbox
> sudo apt-get install virtualbox-guest-additions-iso
> sudo apt-get install vagrant
> vagrant plugin install vagrant-vbguest
</pre>

### Installation Links

[Vagrant](https://developer.hashicorp.com/vagrant/install)

[VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads)

2. Check to make sure virtualization extensions are enabled.

Run this command to see if virtualization is enabled (if VT-x is present, you should be good to go)
```> lscpu | grep "Virtualization"```
If not, [these instructions](https://www.geeksforgeeks.org/linux-how-to-detect-if-vt-x-has-been-turned-on-in-the-bios/) can help you enable virtualization in your OS.

3. Clone this repo and create the VM
The following steps will create and provision the VM, installing required packages to build, deploy, and run a VEuPathDB website
<pre>
> git clone git@github.com:VEuPathDB/vagrant-rocky8-webserver.git
> cd vagrant-rocky8-webserver
> vagrant up
</pre>

Note 1: This can take quite a while (30+ minutes) to download and install the OS and other dependencies into your VM.

Note 2: If you encounter a timeout at "SSH auth method: private key", see [Trouble Shooting #1](https://github.com/VEuPathDB/vagrant-rocky8-webserver/edit/main/README.md#trouble-shooting-1) below

4. SSH into the box
<pre>
> vagrant ssh
</pre>

5. Resize installation partition.  The Vagrantfile specifies 25gb but the created partitions may not use it all, resulting in out-of-disk errors later on.  To expand to use the entire disk, run:
<pre>
> sudo fdisk -l
      (may show sda5 using 10gb or less; should be close to 25gb)
> sudo parted /dev/sda
(parted) print list                                                       
Warning: Not all of the space available to /dev/sda appears to be used, you can fix the GPT to use all of the space (an extra 31457280 blocks) or continue with the current setting? 
Fix/Ignore? Fix
(parted) resizepart 5 100%
Warning: Partition /dev/sda5 is being used. Are you sure you want to continue?
Yes/No? Yes
(parted) quit
> sudo fdisk -l
      (should now show full usage of 25gb in /dev/sda5)
> sudo xfs_growfs /dev/sda5
</pre>
 
6. Log out and back in again to get a clean shell, this time with your local SSH keys
<pre>
> exit
> vagrant ssh -- -A
</pre>

7. Add your github credentials to ~/.bashrc and source it
<pre>
export GITHUB_USERNAME=#####
export GITHUB_TOKEN=#####
</pre>

8. Create a website build framework and build initial tarballs of all four cohorts
<pre>
> bash /vagrant/build_installs.sh
</pre>
If you encounter "Permission Denied" errors accessing Github, recheck your GITHUB_* env vars and that you sshed in with the -A option.  If it still does not work, try the gotcha fixes [here](https://veupathdb.atlassian.net/wiki/spaces/TECH/pages/108560402/Deploy+Containerized+Services+for+Local+Development#Gotchas-around-SSH-Agent).

9. Build out a directory structure for sites and create test sites for each cohort (TODO: use tomcat_instance_framework here)
<pre>
> sudo bash /vagrant/site_installs.sh
</pre>

10. Create conifer configuration dependencies

You will need different conifer_site_vars.yml files for each cohort site.  To start out, copy a conifer_site_vars.yml file from a genomics dev site on palm into `/home/vagrant/site_builds/site_vars/conifer_site_vars.yml.plasmo`.

11. Unpack and configure sites

Try to deploy the genomics site by running the command:
<pre>
> ./gus-site-build-deploy/bin/veupath-unpack-and-configure.sh ~/site_builds/build/api/ApiCommonPresenters_*.tar.gz /var/www/test.plasmodb.org site_vars/conifer_site_vars.yml.plasmo
</pre>

Currently this step is failing on a conifer error due to the new python+ansible setup in Rocky 9.  This needs to be fixed up!

12. When finished testing your local website, destroy the VM with
<pre>
> vagrant destroy -f
</pre>

### Trouble Shooting #1

If you encounter a timeout at "SSH auth method: private key" when bringing up the box the first time, try this fix:

    - Run "vagrant halt", which will shut down the attempted boot
    - Bring up VirtualBox
    - Right click on your VM and select Settings...
    - Select "System"
    - Check the checkbox next to "Enable EFI" and click OK

    - Run "vagrant up" again

