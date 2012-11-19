# Debian specifix stuff
class nfs::server::debian(
  $nfs_v4 = false,
  $nfs_v4_idmap_domain = undef
) {

  class{ 'nfs::client::debian':
    nfs_v4              => $nfs_v4,
    nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
  }

  package { 'nfs-kernel-server':
      ensure => 'installed',
  }

  case nfs::server::debian::nfs_v4 {
    true: {
      service {
        'nfs-kernel-server':
          ensure    => running,
          subscribe => [
            Concat['/etc/exports'],
            Augeas['/etc/idmapd.conf', '/etc/default/nfs-common']
            ],
      }
    } default: {
      service {
      'nfs-kernel-server':
        ensure    => running,
        subscribe => Concat['/etc/exports'],
      }
    }
  }
}
