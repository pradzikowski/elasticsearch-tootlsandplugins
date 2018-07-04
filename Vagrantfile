# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
   config.vm.box = "centos/7"
   config.vm.provision "shell", path: "provision.sh"

   config.vm.synced_folder ".", "/vagrant"

   config.vm.network :private_network, ip: "192.168.50.4"
   
   config.vm.provider "virtualbox" do |v|
     v.name = "virtualbox"
     v.memory = 2048
   end
   
   config.vm.provider "hyperv" do |hv|
      hv.memory = 2048
   end
end
