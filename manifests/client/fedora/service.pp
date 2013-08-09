# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::fedora::service {

  Service {
    require => Class['nfs::client::fedora::configure']
  }

  if $nfs::client::fedora::nfs_v4 {
    $nfs4_services_ensure = 'running'
  } else {
    $nfs4_services_ensure = 'stopped'
  }

  if $nfs::client::fedora::nfs_v4_kerberized {
    $nfs4_kerberized_services_ensure = 'running'
  } else {
    $nfs4_kerberized_services_ensure = 'stopped'
  }

  if $nfs::client::fedora::nfs_v4_kerberized {
    service { 'nfs-secure': 
      provider  => 'systemd',
      ensure    => $nfs4_kerberized_services_ensure,
      enable    => $nfs::client::fedora::nfs_v4_kerberized,
      hasstatus => true,
   }
  }
    
  service { 'nfs-idmap':
    provider  => 'systemd',
    ensure    => $nfs4_services_ensure,
    enable    => $nfs::client::fedora::nfs_v4,
    hasstatus => true,
  }

  
  if !defined(Service['nfs-server']) {
    service { 'nfs-server':
      provider  => 'systemd',
      name      => 'nfs-server',
      ensure    => running,
      enable    => true,
      hasstatus => true,
    }    
  }

  service {'nfs-lock':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    require    => Package["nfs-utils"]
  }

  service {"rpcbind":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => [Package["rpcbind"], Package["nfs-utils"]],
  }
}
