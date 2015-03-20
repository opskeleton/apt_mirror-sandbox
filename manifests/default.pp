node default {

  class { 'apt_mirror':
    base_path  => '/data'
  }

  apt_mirror::mirror { 'utopic':
    mirror     => 'il.archive.ubuntu.com',
    os         => 'ubuntu',
    release    => ['utopic', 'utopic-updates', 'utopic-backports'],
    components => ['main', 'restricted', 'universe', 'multiverse']
  }

  apt_mirror::mirror { 'extras':
    mirror     => 'extras.ubuntu.com',
    os         => 'ubuntu',
    release    => ['utopic'],
    components => ['main']
  }

  include ::nginx

  nginx::resource::vhost { $::hostname:
    ensure    => present,
    www_root  => '/var/spool/apt-mirror/mirror/il.archive.ubuntu.com/ubuntu/pool/',
    autoindex => 'on'
  }

  file{'/data':
    ensure => directory,
  } ->

  mkfs::device {'/dev/vda':
    dest   => '/data'
  }


}
