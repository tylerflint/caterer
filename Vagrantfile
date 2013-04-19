#!/usr/bin/env ruby

Vagrant.configure("2") do |config|

  # ubuntu
  config.vm.box     = 'precise'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpus", "2", "--memory", "1024", "--cpuexecutioncap", "75"]
  end

  config.vm.network :private_network, ip: "33.33.33.10"

  config.ssh.forward_agent = true

end