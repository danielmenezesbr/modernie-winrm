# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# If you copy this file, dont't delete this comment.
# This Vagrantfile was created by Daniel Menezes:
#   https://github.com/danielmenezesbr/modernie-winrm
#   E-mail: daniel at gmail dot com
##

##
# Version: 0.0.2
##


require_relative 'ie-box-automation-plugin.rb'


Vagrant.configure("2") do |config|

  config.vm.box = "microsoft.ie/ie11.win7"
  config.vm.box_url = "file://IE11 - Win7.box"
  config.vm.boot_timeout = 600

  config.vm.guest = :windows

  config.vm.communicator = :winrm       if provisioned?
  config.winrm.username = "IEUser"      if provisioned?
  config.winrm.password = "Passw0rd!"   if provisioned?

  config.ssh.username = "IEUser"
  config.ssh.password = "Passw0rd!"
  config.ssh.insert_key = false

  config.vm.box_check_update = false

  config.vm.synced_folder ".", "/vagrant", disabled: true                     if not provisioned?
  config.vm.synced_folder "./ExtraFolder", "c:/ExtraFolder", create: false    if provisioned?

  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true

     # Customize the amount of memory on the VM:
     vb.memory = "1024"
  end

  config.vm.provision "file", source: "./tools", destination: "c:/users/IEUser"
  config.vm.provision "winrm", type: "ie_box_automation"
end
