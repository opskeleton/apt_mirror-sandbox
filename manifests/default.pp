node default {

  $base_path = '/data'
  $release = 'vivid'
  $origin = 'us.archive.ubuntu.com'

  class { 'apt_mirror':
    base_path  => $base_path
  }

  apt_mirror::mirror { $release:
    mirror     => $origin,
    os         => 'ubuntu',
    release    => [$release, "${release}-updates", "${release}-backports"],
    components => ['main', 'restricted', 'universe', 'multiverse'],
    alt_arch   => ['i386']
  }

  apt_mirror::mirror { 'extras':
    mirror     => 'extras.ubuntu.com',
    os         => 'ubuntu',
    release    => [$release],
    components => ['main'],
    alt_arch   => ['i386']
  }

  apt_mirror::mirror { 'security':
    mirror     => 'security.ubuntu.com',
    os         => 'ubuntu',
    release    => ["${release}-security"],
    components => ['main', 'restricted', 'universe', 'multiverse'],
    alt_arch   => ['i386']
  }

  include ::nginx

  nginx::resource::vhost { $::hostname:
    ensure               => present,
    use_default_location => false
  }

  nginx::resource::location { 'ubuntu':
    ensure    => present,
    www_root  => "${base_path}/mirror/${origin}/",
    location  => '/ubuntu',
    vhost     => $::hostname,
    autoindex => 'on'
  }

  nginx::resource::location { 'ubuntu-extras':
    ensure         => present,
    location_alias => "${base_path}/mirror/extras.ubuntu.com/ubuntu/",
    location       => '/ubuntu-extras',
    vhost          => $::hostname,
    autoindex      => 'on'
  }

  nginx::resource::location { 'ubuntu-security':
    ensure         => present,
    location_alias => "${base_path}/mirror/security.ubuntu.com/ubuntu/",
    location       => '/ubuntu-security',
    vhost          => $::hostname,
    autoindex      => 'on'
  }

  file{$base_path:
    ensure => directory,
  } ->

  mkfs::device {'/dev/vda':
    dest   => '/data'
  }


}
