# -*- mode: ruby -*-
# vi: set ft=ruby :

MIRROR=ENV['MIRROR'] || 'us.archive.ubuntu.com'

update = <<SCRIPT
if [ ! -f /tmp/up ]; then
  sudo sed -i.bak "s/us.archive.ubuntu.com/#{MIRROR}/g" /etc/apt/sources.list
  sudo sed -i.bak '/deb-src/d' /etc/apt/sources.list
  sudo apt-get update 
  touch /tmp/up
fi
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define :aptmirror do |node|
    device = ENV['VAGRANT_BRIDGE'] || 'eth0'

    env  = ENV['PUPPET_ENV'] || 'dev'

    node.vm.box = 'ubuntu-16.04_puppet-3.8.7' 
    node.vm.network :private_network, ip: '192.168.1.201'

    node.vm.provider :libvirt do |domain,o|
      domain.uri = 'qemu+unix:///system'
      domain.host = "aptmirror.local"
      domain.memory = 2048
      domain.cpus = 2
      domain.storage :file, :size => '500G', :path => 'aptmirror.qcow2'
      domain.storage_pool_name = 'aptmirror'
      o.vm.synced_folder './', '/vagrant', type: 'nfs'
	o.vm.network :public_network, :bridge => device,:dev => device, :mac => '52:54:00:ff:03:08'
    end

    node.vm.provision :shell, inline: 'hostnamectl set-hostname aptmirror.local'
    node.vm.provision :shell, :inline => update
    node.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.manifest_file  = 'default.pp'
      puppet.options = "--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env} "
    end
  end

end
