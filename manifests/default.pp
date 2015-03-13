node default {

  class { 'apt_mirror': }

  apt_mirror::mirror { 'trusty':
    mirror     => 'il.archive.ubuntu.com',
    os         => 'ubuntu',
    release    => ['trusty', 'trusty-updates', 'trusty-backports'],
    components => ['main', 'restricted', 'universe', 'multiverse'],
  }

  apt_mirror::mirror { 'extras':
    mirror     => 'extras.ubuntu.com',
    os         => 'ubuntu',
    release    => ['trusty'],
    components => ['main'],
  }
}
