# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# If you copy this file, dont't delete this comment.
# This Vagrantfile was created by Daniel Menezes:
#   https://github.com/danielmenezesbr/modernie-winrm
#   E-mail: danielmenezes at gmail dot com
##

require 'rubygems'
require 'net/ssh'
require 'logger'
require 'log4r'

# TODO
# ====
#


# Function to check whether VM was already provisioned
def provisioned?(vm_name='default', provider='virtualbox')
  File.exist?(".vagrant/machines/#{vm_name}/#{provider}/action_provision")
end




module LocalCommand

    class Config < Vagrant.plugin("2", :config)
        #attr_accessor :command
    end

    class MyPlugin < Vagrant.plugin("2")
        name "ie_box_automation"

        config(:ie_box_automation, :provisioner) do
            Config
        end

        provisioner(:ie_box_automation) do
            Provisioner
        end
    end

    class Provisioner < Vagrant.plugin("2", :provisioner)

        def initialize(machine, config)
            super
            @logger  = Log4r::Logger.new("vagrant::ieautomation")
        end

        def execute_command(ssh, command, show)
            @logger.debug ("command: #{command}")
            res = ssh.exec!(command)
            @logger.debug ("result: #{res}")
            puts res if show
        end

        def provision
            #result = system "#{config.command}"
            begin
                ssh_info = nil
                while true
                    ssh_info = @machine.ssh_info
                    break if ssh_info
                    sleep 1
                    @logger.debug ("wait ssh_info")
                end

                ssh = Net::SSH.start(ssh_info[:host], ssh_info[:username], :password => ssh_info[:password], :port => ssh_info[:port])

                execute_command(ssh, "ls -la", false)

                execute_command(ssh, "[ ! ./tools.zip ] && echo 'ERROR! File ./tools.zip not found on guest machine. Was the file provisioner executed?'", true)

                execute_command(ssh, "./7z.exe e tools.zip -y", false)

                puts "Disabling firewall..."
                execute_command(ssh, "NetSh Advfirewall set allprofiles state off", false)

                puts "Changing network location..."
                execute_command(ssh, "./NLMtool_staticlib.exe -setcategory private", false)

                puts "Turn off User Account Control..."
                execute_command(ssh, "cmd /c \"reg add HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System /v EnableLUA /d 0 /t REG_DWORD /f /reg:64\"", false)

                puts "Creating link to config WinRM on Startup..."
                execute_command(ssh, "mv ./configWinRM.bat.lnk \"/cygdrive/c/Users/IEUser/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup\"", false)

                puts 'Shutting down guest machine...'
                execute_command(ssh, "shutdown -t 0 -s -f", false)

                $done = false;
                while !$done do
                    begin
                        result = Vagrant::Util::Subprocess.execute(
                            'vagrant',
                            'status',
                            :notify => [:stdout, :stderr],
                            #:workdir => config.cwd,
                            :env => {PATH: ENV["VAGRANT_OLD_ENV_PATH"]},
                        ) do |io_name, data|
                            #@machine.env.ui.debug "[#{io_name}] #{data}"
                            if data.include? "The VM is running"
                                puts 'The VM is running... Waiting shutdown...'
                            else
                                $done = true
                                puts 'The VM is not running. Next command should be vagrant up...'
                            end
                        end
                        sleep(50)
                    rescue Exception => e
                        $done = true
                        puts 'Exception...'
                        raise
                    end
                end
                ssh.close
            rescue Exception => e
                puts "uncaught #{e} exception while handling connection: #{e.message}"
                raise
            end
        end
    end
end
