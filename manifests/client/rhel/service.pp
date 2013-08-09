# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::rhel::service {

  Service {
    require => Class['nfs::client::rhel::configure']
  }

  if $nfs::client::rhel::nfs_v4 {
    $nfs4_services_ensure = 'running'
  } else {
    $nfs4_services_ensure = 'stopped'
  }

  if $nfs::client::fedora::nfs_v4_kerberized {
    $nfs4_kerberized_services_ensure = 'running'
  } else {
    $nfs4_kerberized_services_ensure = 'stopped'
  }

  service { ['rpcgssd', 'rpcsvcgssd', 'rpcidmapd']:
    ensure    => $nfs4_kerberized_services_ensure,
    enable    => $nfs::client::rhel::nfs_v4_kerberized,
    hasstatus => true,
  }

  if !defined(Service['nfs']) {
    service { 'nfs':
      ensure    => $nfs4_services_ensure,
      enable    => $nfs::client::rhel::nfs_v4,
      hasstatus => true,
    }    
  }

  service {"nfslock":
    ensure     => running,
    enable    => true,
    hasstatus => true,
    require => $nfs::client::rhel::osmajor ? {
      6 => Service["rpcbind"],
      5 => [Package["portmap"], Package["nfs-utils"]]
    },
  }

  service { "netfs":
    enable  => true,
    require => $nfs::client::rhel::osmajor ? {
      6 => Service["nfslock"],
      5 => [Service["portmap"], Service["nfslock"]],
    },
  }

  if $nfs::client::rhel::osmajor == 6 {
    service {"rpcbind":
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require => [Package["rpcbind"], Package["nfs-utils"]],
    }
  } elsif $nfs::client::rhel::osmajor == 5 {
    service { "portmap":
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require => [Package["portmap"], Package["nfs-utils"]],
    }
  }
}
