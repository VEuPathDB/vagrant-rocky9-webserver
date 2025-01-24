# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "rockylinux/9"
  config.vm.box_version = "4.0.0"

  config.vm.disk :disk, size: "25GB", primary: true

  # forwarding agent from host allows github access and ssh tunneling to VEuPathDB servers
  config.ssh.forward_agent = true

  # Forward Tomcat instance HTTP ports to identical ports on host
  #   (only allow access via 127.0.0.1 to disable public access)
  config.vm.network "forwarded_port", guest: 19010, host: 19010, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 19020, host: 19020, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 19030, host: 19030, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 19040, host: 19040, host_ip: "127.0.0.1"

  config.vm.provision "shell", path: "./bin/1.0-provision.sh"

end
