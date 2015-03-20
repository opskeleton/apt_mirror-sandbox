node default {

  $base_path = '/data'
  $release = 'utopic'

  class { 'apt_mirror':
    base_path  => $base_path
  }

  apt_mirror::mirror { $release:
    mirror     => 'il.archive.ubuntu.com',
    os         => 'ubuntu',
    release    => [$release, "${release}-updates", "${release}-backports"],
    components => ['main', 'restricted', 'universe', 'multiverse']
  }

  apt_mirror::mirror { 'extras':
    mirror     => 'extras.ubuntu.com',
    os         => 'ubuntu',
    release    => [$release],
    components => ['main']
  }

  include ::nginx

  nginx::resource::vhost { $::hostname:
    ensure    => present,
    www_root  => "${base_path}/mirror/il.archive.ubuntu.com/ubuntu/pool/",
    autoindex => 'on'
  }

  file{$base_path:
    ensure => directory,
  } ->

  mkfs::device {'/dev/vda':
    dest   => '/data'
  }


}
