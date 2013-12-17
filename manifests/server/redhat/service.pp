class nfs::server::redhat::service {

  if defined(Class['firewall']) {
    augeas { 'nfs config':
      context => '/files',
      changes => [
        "set etc/sysconfig/nfs/rquotad_port ${nfs::server::redhat::rquotad_port}",
        "set etc/sysconfig/nfs/lockd_tcpport ${nfs::server::redhat::lockd_tcpport}",
        "set etc/sysconfig/nfs/lockd_udpport ${nfs::server::redhat::lockd_udpport}",
        "set etc/sysconfig/nfs/mountd_port ${nfs::server::redhat::mountd_port}",
        "set etc/sysconfig/nfs/statd_port ${nfs::server::redhat::statd_port}",
        "set etc/sysconfig/nfs/statd_outgoing_port ${nfs::server::redhat::statd_outgoing_port}",
      ],
      notify => Service['nfs'],
    }
  }

  if $nfs::server::redhat::nfs_v4 == true {
      service {"nfs":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["nfs-utils"],
        subscribe  => [ Concat['/etc/exports'], Augeas['/etc/idmapd.conf'] ],
      }
    } else {
      service {"nfs":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["nfs-utils"],
        subscribe  => Concat['/etc/exports'],
     }
  }
}
