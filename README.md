# Vagrant Setup for Running VEuPathDB sites on Rocky 9 VM
Testbed for building websites on Rocky 9 with Java 21 and Tomcat 9

1. Install VirtualBox and Vagrant on your host machine (laptop).
  
Depending on your Linux distribution, you may be able to use native packaging, or will need to follow the vendor instructions.

### Native Packaging Example (your commands may differ)
<pre>
> sudo apt-get install virtualbox
> sudo apt-get install virtualbox-guest-additions-iso
> sudo apt-get install vagrant
> vagrant plugin install vagrant-vbguest
</pre>

### Vendor Installation Links

[Vagrant](https://developer.hashicorp.com/vagrant/install)

[VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads)

2. Check to make sure virtualization extensions are enabled

Run this command to see if virtualization is enabled (if VT-x is present, you should be good to go)
```
> lscpu | grep "Virtualization"
```
If not, [these instructions](https://www.geeksforgeeks.org/linux-how-to-detect-if-vt-x-has-been-turned-on-in-the-bios/) can help you enable virtualization in your OS.

3. Clone this repo and create the VM
The following steps will create and provision the VM, installing required packages to build, deploy, and run a VEuPathDB website
<pre>
> git clone git@github.com:VEuPathDB/vagrant-rocky9-webserver.git
> cd vagrant-rocky9-webserver
> vagrant up
</pre>

Note 1: This can take quite a while (30+ minutes) to download and install the OS and other dependencies into your VM.

Note 2: If you encounter a timeout at "SSH auth method: private key", see [Trouble Shooting #1](https://github.com/VEuPathDB/vagrant-rocky9-webserver/edit/main/README.md#trouble-shooting-1) below

4. SSH into the box
<pre>
> vagrant ssh
</pre>

5. Resize installation partition.  The Vagrantfile specifies 25gb but the created partitions may not use it all, resulting in out-of-disk errors later on.  To expand to use the entire disk, run:
<pre>
> sudo bash /vagrant/bin/fixDiskPartitionSize.sh
</pre>
Note: You will have to confirm the config by interactively typing 'Yes' during the running of this script.

6. Install VEuPathDB Tomcat RPMs and Tomcat Instance Framework (TCIF).  This is done in a separate step in case you need to tweak the Tomcat/TCIF versions.
<pre>
> sudo bash /vagrant/bin/installTomcat.sh
</pre>

7. Supplement ~/.bashrc with github credentials and site tooling
<pre>
export GITHUB_USERNAME=#####
export GITHUB_TOKEN=#####

source /vagrant/bin/devTools.sh
</pre>

8. Log out and back in again to get a clean shell, this time with your local SSH keys
<pre>
> exit
> vagrant ssh -- -A
</pre>

9. Create a website build framework and build initial tarballs of all four cohorts
<pre>
> bash /vagrant/bin/buildSiteArtifacts.sh
</pre>
If you encounter "Permission Denied" errors accessing Github, recheck your GITHUB_* env vars and that you SSHed in with the -A option.  If it still does not work, try the gotcha fixes [here](https://veupathdb.atlassian.net/wiki/spaces/TECH/pages/108560402/Deploy+Containerized+Services+for+Local+Development#Gotchas-around-SSH-Agent).  If it still does not work, see [Trouble Shooting #2](https://github.com/VEuPathDB/vagrant-rocky9-webserver/edit/main/README.md#trouble-shooting-2).

10. Build out a directory structure for sites and create test sites for each cohort (TODO: use tomcat_instance_framework here)
<pre>
> sudo bash /vagrant/bin/buildSiteDeploymentDirs.sh
</pre>

11. Create conifer configuration dependencies

    1. You will need different conifer_site_vars.yml files for each cohort site.  To start out:
        1. `cp /vagrant/sample_confs/conifer_site_vars.yml.test /home/vagrant/site_builds/site_vars/conifer_site_vars.yml.plasmo` and edit to your needs.
        2. Note QA and prod sites have special configs e.g. `/vagrant/sample_confs/conifer_site_vars.yml.qa`
    3. `cp /vagrant/sample_confs/apidb_oauth_creds.sample /usr/local/tomcat_instances/shared/.apidb_oauth_creds` and edit to your needs.
    4. `cp /vagrant/sample_confs/apidb_wdk_key.sample /usr/local/tomcat_instances/shared/.apidb_wdk_key` and edit to your needs.
    5. `cp /vagrant/sample_confs/euparc.sample /home/vagrant/.euparc` and edit to your needs.

To copy all these files into the correct locations in one step (but without any edits), run:
```
bash /vagrant/bin/addSampleConfigs.sh
```

12. Unpack and configure sites

Try to deploy the genomics site by running the command:
<pre>
> ./gus-site-build-deploy/bin/veupath-unpack-and-configure.sh ~/site_builds/build/api/ApiCommonPresenters_*.tar.gz /var/www/test.plasmodb.org site_vars/conifer_site_vars.yml.plasmo
</pre>

13. When finished testing your local website, destroy the VM with
<pre>
> vagrant destroy -f
</pre>

### Trouble Shooting #1

If you encounter a timeout at "SSH auth method: private key" when bringing up the box the first time, try this fix:
```
    - Run "vagrant halt", which will shut down the attempted boot
    - Bring up VirtualBox
    - Right click on your VM and select Settings...
    - Select "System"
    - Check the checkbox next to "Enable EFI" and click OK
    - Run "vagrant up" again
```

### Trouble Shooting #2

If you cannot access github from inside the VM but you can from outside the VM (using the same SSH keys and github crendentials), your key may no longer be ssupported by Rocky (as of Rocky 9.1, crypto-policies enforce 2048-bit RSA key length minimum by default).  RSA keys smaller than 2048 bits are ignored by SSH, and will not be used to connect to Github or VEuPathDB servers).

To generate a new key of sufficient length, go back to your host machine and visit ~/.ssh.  If there is already a id_ed25519.pub, you may have a different problem, since that algorithm should be supported by Rocky 9.  Assuming you do NOT already have a ed25519 key pair, run:
```
> ssh-keygen -t ed25519 -C "your_email@example.com"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/rdoherty/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase): 
Enter same passphrase again:
> ssh-add id_ed25519
```
This will generate a new, stronger key pair and add it to your ssh-agent.  The last step is to [add this key to Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).
