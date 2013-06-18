class nfs::server::rhel(
  $nfs_v4 = false,
  $nfs_v4_idmap_domain = undef,
  $nfs_v4_kerberized = false,
  $nfs_v4_kerberos_realm = undef,
  $rpcgssd_opts = undef,
  $rpcsvcgssd_opts = undef,
  $rpcidmapd_opts = undef,
  $rpcmountd_opts = undef,
) {

  class{ 'nfs::client::rhel':
    nfs_v4                 => $nfs_v4,
    nfs_v4_idmap_domain    => $nfs_v4_idmap_domain,
    nfs_v4_kerberized      => $nfs_v4_kerberized,
    nfs_v4_kerberos_realm  => $nfs_v4_kerberos_realm,
    rpcgssd_opts           => $rpcgssd_opts,
    rpcsvcgssd_opts        => $rpcsvcgssd_opts,
    rpcidmapd_opts         => $rpcidmapd_opts,    
    rpcmountd_opts         => $rpcmountd_opts
  }

  include nfs::server::rhel::install, nfs::server::rhel::service


}

class nfs::server::rhel::install {
  package { 'nfs4-acl-tools':
    ensure => installed,
  }
}


class nfs::server::rhel::service {

  if $nfs::server::rhel::nfs_v4 {
    $nfs_v4_services_ensure = 'running'
    } else {
    $nfs_v4_services_ensure = 'stopped'
    }

    if !defined(Service['nfs']) {
    case $::operatingsystem {
      centos, rhel: {
        service {"nfs":
          ensure     => running,
          enable     => true,
          hasrestart => true,
          hasstatus  => true,
          require    => Package["nfs-utils"],
          subscribe  => [ Concat['/etc/exports'], File['/etc/idmapd.conf'], File['/etc/sysconfig/nfs'] ],
        }
      }
      fedora: {
        service { nfs:
          provider   => 'systemd',
          name       => 'nfs.service',
          ensure     => running,
          enable     => true,
          hasrestart => true,
          hasstatus  => true,
          require    => Package["nfs-utils"],
          subscribe  => [ Concat['/etc/exports'], File['/etc/idmapd.conf'], File['/etc/sysconfig/nfs'] ],
        }
      }
    }
   }
}
