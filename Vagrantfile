# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define :aptmirror do |node|
    bridge = ENV['VAGRANT_BRIDGE']
    bridge ||= 'eth0'

    env  = ENV['PUPPET_ENV']
    env ||= 'dev'

    node.vm.box = 'ubuntu-14.10_puppet-3.7.3' 
    node.vm.network :public_network, :bridge => bridge, :mac => '52:54:00:ff:03:08'
    node.vm.hostname = 'aptmirror.local'

    node.vm.provider :libvirt do |domain|
      domain.uri = 'qemu+unix:///system'
      domain.host = "aptmirror.local"
      domain.memory = 2048
      domain.cpus = 2
      domain.storage :file, :size => '500G', :path => 'aptmirror.qcow2'
    end

    node.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.manifest_file  = 'default.pp'
      puppet.options = "--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}"
    end
  end

end
