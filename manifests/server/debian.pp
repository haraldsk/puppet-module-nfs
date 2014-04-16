# Debian specifix stuff
class nfs::server::debian(
  $nfs_v4 = false,
  $nfs_v4_secure = false,
  $nfs_v4_idmap_domain = undef
) {

  class{ 'nfs::client::debian':
    nfs_v4              => $nfs_v4,
    nfs_v4_secure       => $nfs_v4_secure,
    nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
  }

  package { 'nfs-kernel-server':
      ensure => 'installed',
  }

  if $nfs_v4 == true {
    if $nfs::client::debian::nfs_v4_secure {
      $needgssd = 'yes'
    } else {
      $needgssd = 'no'
    }
    augeas { '/etc/default/nfs-kernel-server':
      context => '/files/etc/default/nfs-kernel-server',
      changes => [ "set NEED_SVCGSSD $needgssd",
                   ],
      }
    service {
      'nfs-kernel-server':
        ensure    => running,
        subscribe => [
          Concat['/etc/exports'],
          Augeas['/etc/idmapd.conf',
                 '/etc/default/nfs-common',
                 '/etc/default/nfs-kernel-server'],
          ],
    }
  } else {
    service {
    'nfs-kernel-server':
      ensure    => running,
    }
  }
}
