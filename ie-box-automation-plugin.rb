# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# If you copy this file, dont't delete this comment.
# This Vagrantfile was created by Daniel Menezes:
#   https://github.com/danielmenezesbr/modernie-winrm
#   E-mail: daniel at gmail dot com
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
