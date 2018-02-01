# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  config.vm.define :aptmirror do |node|
    device = ENV['VAGRANT_BRIDGE'] || 'eth0'
    node.vm.box = 'ubuntu-16.04.3_puppet-4.10.8'
    node.vm.network :private_network, ip: '192.168.1.201'
    node.vm.hostname = "aptmirror.local"

    node.vm.provider :libvirt do |domain,o|
	domain.uri = 'qemu+unix:///system'
	domain.host = "aptmirror.local"
	domain.memory = 2048
	domain.cpus = 2
	domain.storage :file, :size => '500G', :path => 'aptmirror.qcow2'
	domain.storage_pool_name = 'default'
	o.vm.synced_folder './', '/vagrant', type: 'nfs'
	o.vm.network :public_network, :bridge => device,:dev => device, :mac => '52:54:00:ff:03:08'
    end


    node.vm.provision :puppet do |puppet|
	puppet.manifests_path = 'manifests'
	puppet.manifest_file  = 'default.pp'
	puppet.options = "--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml "
    end
  end
end
