class nfs::client (
  $nfs_v4              = $nfs::params::nfs_v4,
  $nfs_v4_mount_root   = $nfs::params::nfs_v4_mount_root,
  $nfs_v4_idmap_domain = $nfs::params::nfs_v4_idmap_domain,
) inherits nfs::params {

  include nfs, nfs::client::service

}

define nfs::client::mount (
  $ensure = 'present',
  $server,
  $share,
) {

  include nfs, nfs::client

  if $nfs::client::nfs_v4 == true {

    class { nfs::configure::nfs_v4::enabled:
      nfs_v4_idmap_domain => $nfs::client::nfs_v4_idmap_domain,
    }

    $_nfs4_share = "${nfs::client::nfs_v4_mount_root}/${share}"

    nfs::mkdir{"${_nfs4_share}": }


    mount {"shared $share by $::clientcert":
      ensure   => present,
      #ensure   => mounted,
      device   => "${server}:/${share}",
      fstype   => "nfs4",
      name     => "${_nfs4_share}",
      options  => '_netdev',
      remounts => false,
      atboot   => false,
      require  => Nfs::Mkdir["${_nfs4_share}"],
    }
  } else {

    nfs::mkdir{"${share}": }


    mount {"shared $share by $::clientcert":
      ensure   => present,
      device   => "${server}:${share}",
      fstype   => "nfs",
      name     => "${share}",
      options  => '_netdev',
      remounts => false,
      atboot   => false,
      require  => Nfs::Mkdir["${share}"],
    }


  }


}

class nfs::client::service {

  case $::operatingsystem {

    'ubuntu', 'debian': {
      service {'nfs-kernel-server':
        ensure => stopped,
      }
    } 'redhat', 'centos', 'sles': {
      service {'nfs':
        ensure => running,
      }
    }
    default: {
      fail("Not tested on $operatingsystem")
    }
  }

}
