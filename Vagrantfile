# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
mkdir /home/vagrant/isodev
cp -fr -a /vagrant/. /home/vagrant/isodev/
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
    v.name = "isodev"
  end

  config.vm.box = "hashicorp/bionic64"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.provision "shell", inline: $script  
end