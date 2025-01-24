# Vagrant Setup for Running VEuPathDB sites on Rocky 9 VM
Testbed for building websites on Rocky 9 with Java 21 and Tomcat 9

## Prerequisites

### Check to make sure virtualization extensions are enabled

Run this command to see if virtualization is enabled (if VT-x is present, you should be good to go)
```
> lscpu | grep "Virtualization"
```
If not, [these instructions](https://www.geeksforgeeks.org/linux-how-to-detect-if-vt-x-has-been-turned-on-in-the-bios/) can help you enable virtualization in your OS.

### Install VirtualBox and Vagrant on your host machine (laptop)

Depending on your Linux distribution, you may be able to use native packaging, or will need to follow the vendor instructions.

#### Native Packaging Example (your commands may differ)
<pre>
> sudo apt-get install virtualbox
> sudo apt-get install virtualbox-guest-additions-iso
> sudo apt-get install vagrant
> vagrant plugin install vagrant-vbguest
</pre>

#### Vendor Installation Links

[Vagrant](https://developer.hashicorp.com/vagrant/install)

[VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads)

## Create and Configure the Rocky 9 Webserver VM

### 1. Clone this repo and create the VM

The following steps will create and provision the VM, installing required packages to build, deploy, and run a VEuPathDB website
<pre>
> git clone git@github.com:VEuPathDB/vagrant-rocky9-webserver.git
> cd vagrant-rocky9-webserver
> vagrant up
</pre>

Note 1: This can take quite a while (30+ minutes) to download and install the OS and other dependencies into your VM.

Note 2: If you encounter a timeout at "SSH auth method: private key", see [Trouble Shooting #1](https://github.com/VEuPathDB/vagrant-rocky9-webserver/edit/main/README.md#trouble-shooting-1) below

### 2. SSH into the VM
<pre>
> vagrant ssh
</pre>

### 3. Run Post-Provision Script
<pre>
> sudo bash /vagrant/bin/2.0-post-provision.sh
</pre>

This script runs 5 subscripts that perform the following actions:

a. Resize installation partition.  The Vagrantfile specifies 25gb but the created partitions may not use it all, resulting in out-of-disk errors later on.  This step expands the partitions to use the entire disk.
```
Note: You will have to confirm the config by interactively typing 'Yes' during the running of this script.
```
This portion can be rerun manually via `sudo bash /vagrant/bin/2.1-fixDiskPartitionSize.sh`

b. Install VEuPathDB Tomcat RPMs and the Tomcat Instance Framework (TCIF).  This is done in a separate step in case you need to tweak the Tomcat/TCIF versions.

This portion can be rerun manually via `sudo bash /vagrant/bin/2.2-installTomcat.sh`

c. Copy sample configs to a `conf/` dir within your `vagrant-rocky9-webserver` checkout and create soft links in the VM to point to those config files.  Also appends supplemental bash setup into the vagrant user's .bashrc

This portion can be rerun manually via `sudo bash /vagrant/bin/2.3-linkSampleConfigs.sh`

d. Create Tomcat instances for a site in each cohort (PlasmoDB, OrthoMCL, ClinEpiDB, MicrobiomeDB) and start them up.

Note: the ports these Tomcat instances will run on correspond to the VM port mappings defined in the Vagrantfile.  This is how you will access the sites from a browser on your host machine.

This portion can be rerun manually via `sudo bash /vagrant/bin/2.4-createTomcatInstances.sh`

e. Create website deployment directories for test websites for each cohort (akin to 'dev sites' on VEuPathDB servers) and a QA Plasmo site, and create domain-named soft links to the webapp dirs.  

This portion can be rerun manually via `sudo bash /vagrant/bin/2.5-buildSiteDeploymentDirs.sh`

### 4. Configure Your Server

Step 3.c above copies sample config files from /vagrant/conf_samples into /vagrant/conf, but many values will need to be filled in to support conifer configuration and be able to successfully run the sites.  Here is a comprehensive list of changes you will need to make:

TODO: fill in!  Some old notes below

    1. You will need different conifer_site_vars.yml files for each cohort site.  To start out:
        1. `cp /vagrant/sample_confs/conifer_site_vars.yml.test /home/vagrant/site_builds/site_vars/conifer_site_vars.yml.plasmo` and edit to your needs.
        2. Note QA and prod sites have special configs e.g. `/vagrant/sample_confs/conifer_site_vars.yml.qa`
    3. `cp /vagrant/sample_confs/apidb_oauth_creds.sample /usr/local/tomcat_instances/shared/.apidb_oauth_creds` and edit to your needs.
    4. `cp /vagrant/sample_confs/apidb_wdk_key.sample /usr/local/tomcat_instances/shared/.apidb_wdk_key` and edit to your needs.
    5. `cp /vagrant/sample_confs/euparc.sample /home/vagrant/.euparc` and edit to your needs.

### 5. Re-source .bashrc
```
> source ~/.bashrc
```
This will pick up any additional environment variables, alias, functions you defined in /vagrant/conf/bashrc_addons

### 6. Build, then Unpack and Configure the 4 Cohort Test Sites
<pre>
> bash /vagrant/bin/3.0-site-setup.sh 
</pre>

This script runs 3 subscripts that perform the following actions:

a. Create a website build framework and check out the source code.  The result of this operation can be seen in `/home/vagrant/site_builds`.

Note: If you encounter "Permission Denied" errors accessing Github, recheck your GITHUB_* env vars and that you SSHed in with the -A option.  If it still does not work, try the gotcha fixes [here](https://veupathdb.atlassian.net/wiki/spaces/TECH/pages/108560402/Deploy+Containerized+Services+for+Local+Development#Gotchas-around-SSH-Agent).  If it still does not work, see [Trouble Shooting #2](https://github.com/VEuPathDB/vagrant-rocky9-webserver/edit/main/README.md#trouble-shooting-2).

This portion can be rerun manually via `bash /vagrant/bin/3.1-setUpSiteBuilds.sh`

b. Build initial website tarballs for all four cohorts

This portion can be rerun manually via `bash /vagrant/bin/3.2-buildSiteArtifacts.sh`

c. Unpack the resulting tarballs into our test site directories, configure the sites, and deploy the webapps to the correct Tomcat instances

This portion can be rerun manually via `bash /vagrant/bin/3.3-unpackAndConfigureSites.sh`

### 7. Deploy Configured Webapps

oracletunnel

4.0-deploySites.sh


Note: the QA Plasmo site should configure without failure; however, its configuration file uses the Oracle oci driver's connection URL, which is not supported, so the QA webapp is not deployed to Tomcat

### 8. View and Test the Websites (limited by omission of EDA/VDI)

Some parts of the sites' web client requires accessing the site by the configured domain name.  To allow this on your host machine, add the following lines to your `/etc/hosts` file (requires sudo).  Note the whitespace between the IP address and the domain should be a TAB character (\t).
```
127.0.0.1       test.plasmodb.org
127.0.0.1       test.orthomcl.org
127.0.0.1       test.clinepidb.org
127.0.0.1       test.microbiomedb.org
```

If all went well above, you should be able to access the sites at the following URLs.  Note that FireFox uses its own DNS and does not support changes to /etc/hosts, so use Brave or similar to access the sites.
```
http://test.plasmodb.org:
```


### 9. When finished testing your local website, destroy the VM with
<pre>
> vagrant destroy -f
</pre>

## Additional Help

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
