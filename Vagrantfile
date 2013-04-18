#!/usr/bin/env ruby

Vagrant.configure("2") do |config|

  # ubuntu
  # config.vm.box     = 'precise'
  # config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  # centos
  config.vm.box     = 'pagoda_cent6_minimal'
  config.vm.box_url = 'https://s3.amazonaws.com/vagrant.pagodabox.com/boxes/centos-6.4-x86_64-minimal.box'

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpus", "2", "--memory", "1024", "--cpuexecutioncap", "75"]
  end

  config.ssh.forward_agent = true

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['cookbooks']    
    chef.add_recipe 'users'
  end

end