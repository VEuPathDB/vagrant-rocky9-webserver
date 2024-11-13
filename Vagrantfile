# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "rockylinux/9"
  config.vm.box_version = "4.0.0"

  config.vm.disk :disk, size: "25GB", primary: true

  # Don't always want to do this
  #config.ssh.forward_agent = true

  # Forward Tomcat's default port 8080 to 8080 on host +
  #   only allow access via 127.0.0.1 to disable public access
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"

  config.vm.provision "shell", path: "./bin/provision.sh"

end
