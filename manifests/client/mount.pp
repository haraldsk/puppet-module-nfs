define nfs::client::mount (
  $ensure = 'present',
  $server,
  $share,
) {

  include nfs::client

  if $nfs::client::nfs_v4 == true {

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
