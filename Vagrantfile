# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-'SCRIPT'
echo "Resizing sda4 to the alloted size"
parted -s -a opt /dev/sda "resizepart 4 100%"
echo "Alerting ext filesystem to the new size"
sudo xfs_growfs /dev/sda4
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "rockylinux/8"
  config.vm.box_version = "8.0.0"

  config.vm.disk :disk, size: "25GB", primary: true

  # Don't always want to do this
  #config.ssh.forward_agent = true

  # this didn't work
  #config.vm.provider "virtualbox" do |domain|
  #  domain.customize ["modifyvm", :id, "--firmware", "efi"]
  #end

  # this didn't work either
  #config.vm.provision "shell", inline: $script
  #config.vm.provision "shell", path: "system_installs.sh"

end
