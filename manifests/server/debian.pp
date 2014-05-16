# Debian specifix stuff
class nfs::server::debian(
  $nfs_v4              = false,
  $nfs_v4_idmap_domain = undef,
  $manage_service      = $::nfs::server::nfs_manage_service,
) inherits nfs::server {

  class{ 'nfs::client::debian':
    nfs_v4              => $nfs_v4,
    nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
  }

  package { 'nfs-kernel-server':
      ensure => 'installed',
  }

  $do_manage_service = str2bool($manage_service)
  if $do_manage_service {
    if $nfs_v4 == true {
      service {'nfs-kernel-server':
        ensure    => running,
        subscribe => [
          Concat['/etc/exports'],
          Augeas['/etc/idmapd.conf', '/etc/default/nfs-common'],
        ],
      }
    } else {
      service {'nfs-kernel-server':
        ensure    => running,
        subscribe => Concat['/etc/exports'],
      }
    }
  }
}
