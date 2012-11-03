class nfs::server::redhat {

    include nfs::client::redhat
    include nfs::server::redhat::install, nfs::server::redhat::service


}

class nfs::server::redhat::install {

  ensure_resource( 'package', 'nfs-utils',        { 'ensure' => 'installed' } )
  ensure_resource( 'package', 'rpcbind',          { 'ensure' => 'installed' } )
  ensure_resource( 'package', 'nfs4-acl-tools',   { 'ensure' => 'installed' } )

}


class nfs::server::redhat::service {

      service {"nfs":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["nfs-utils"],
        subscribe  => Augeas['/etc/idmapd.conf'],
      }

}
