class nfs::server::debian(
  $nfs_v4 = false,
  $nfs_v4_idmap_domain = undef
) {

  class{ 'nfs::client::debian':
    nfs_v4              => $nfs_v4,
    nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
  }

  include nfs::server::debian::install,
    nfs::server::debian::configure,
    nfs::server::debian::service

  Class['nfs::server::debian::install']
    -> Class['nfs::server::debian::configure']
    -> Class['nfs::server::debian::service']

}

class nfs::server::debian::install {

  ensure_resource( 'package', 'nfs-kernel-server', { 'ensure' => 'installed' } )
  ensure_resource( 'package', 'nfs-common',        { 'ensure' => 'installed' } )
  ensure_resource( 'package', 'nfs4-acl-tools',    { 'ensure' => 'installed' } )
}
class nfs::server::debian::configure {

}

class nfs::server::debian::service {
  if nfs::server::debian::nfs_v4 == true {
    service {
      'nfs-kernel-server':
        ensure    => running,
        subscribe => [ Concat['/etc/exports'], Augeas['/etc/idmapd.conf', '/etc/default/nfs-common'] ],
        require   => Class['nfs::server::debian::configure']
    }
  } else {
    service {
      'nfs-kernel-server':
        ensure    => running,
        subscribe => Concat['/etc/exports'], 
        require   => Class['nfs::server::debian::configure']
    }
  }
}
