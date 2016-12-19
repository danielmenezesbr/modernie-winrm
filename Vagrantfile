# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# If you copy this file, dont't delete this comment.
# This Vagrantfile was created by Daniel Menezes:
#   https://github.com/danielmenezesbr/modernie-winrm
#   E-mail: dnaiel at gmail dot com
##

require 'rubygems'
require 'net/ssh'

# TODO
# ====
#   Uses config.ssh in Net::SSH.start 
#   use compacted version of Akagi32 (needs unzip) with password
#   test in win8/10
#   add logic as plugin 
#   add activate (view desktop information)
#   move SeleniumServer-node to other project


module LocalCommand

    class Config < Vagrant.plugin("2", :config)
        attr_accessor :command
    end

    class MyPlugin < Vagrant.plugin("2")
        name "local_shell"

        config(:local_shell, :provisioner) do
            Config
        end

        provisioner(:local_shell) do
            Provisioner
        end
    end

    class Provisioner < Vagrant.plugin("2", :provisioner)
        def provision
            #result = system "#{config.command}"
            begin
                ssh = Net::SSH.start("localhost", "IEUser", :password => "Passw0rd!", :port => 2222)

                puts "Disabling firewall..."
                res = ssh.exec!("NetSh Advfirewall set allprofiles state off")
                #puts res
                
                puts "Changing category of network..."
                res = ssh.exec!("./tools/NLMtool_staticlib.exe -setcategory private")
                #puts res
                
                puts "Creating link to config WinRM on Startup..."
                res = ssh.exec!("mv ./tools/ConfigWinRM.lnk \"/cygdrive/c/Users/IEUser/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup\"")
                puts res
                
                puts "Restarting machine..."
                res = ssh.exec!("shutdown -t 0 -r -f")
                
                puts 'After shutdown...'
                $done = false;
                while !$done do
                    begin
                        printf '.'
                        res = ssh.exec!("pwd")
                        #puts res
                        sleep(1)
                    rescue Exception => e
                        $done = true
                        puts 'SSH disconnected'
                    end
                end
                
                puts 'Wait for openssh...'
                $done = false;
                while !$done do
                    begin
                        printf '.'
                        ssh = Net::SSH.start("localhost", "IEUser", :password => "Passw0rd!", :port => 2222)
                        #puts res
                        $done = true
                    rescue
                        sleep(1)
                    end
                end
                
                # shutdown machine
                ssh.exec!("shutdown -t 0 -s -f")
                
                # TODO: remove shortcut
                
                ssh.close        
            rescue
                puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
            end
        end
    end
end

# Function to check whether VM was already provisioned
def provisioned?(vm_name='default', provider='virtualbox')
  File.exist?(".vagrant/machines/#{vm_name}/#{provider}/action_provision")
end


Vagrant.configure("2") do |config|

  config.vm.box = "microsoft.ie/ie11.win7"
  config.vm.box_url = "file://IE11 - Win7.box"
  
  config.vm.guest = :windows
  
  config.vm.communicator = :winrm       if provisioned?
  config.winrm.username = "IEUser"      if provisioned?
  config.winrm.password = "Passw0rd!"   if provisioned?
  config.vm.synced_folder "./ExtraFolder", "c:/ExtraFolder", create: false  if provisioned?

  config.ssh.username = "IEUser"
  config.ssh.password = "Passw0rd!"
  config.ssh.insert_key = false

  config.vm.box_check_update = false

  config.vm.synced_folder ".", "/vagrant", disabled: true       if not provisioned?

  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true
  
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
  end
  
  config.vm.provision "file", source: "./tools", destination: "c:/users/IEUser"  
  config.vm.provision "list-files", type: "local_shell", command: "dir"
end
