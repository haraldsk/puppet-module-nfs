class nfs::server::fedora(
  $nfs_v4 = false,
  $nfs_v4_idmap_domain = undef,
  $nfs_v4_kerberized = false,
  $nfs_v4_kerberos_realm = undef,
  $rpcgssd_opts = undef,
  $rpcsvcgssd_opts = undef,
  $rpcidmapd_opts = undef,
  $rpcmountd_opts = undef,
) {

  class{ 'nfs::client::fedora':
    nfs_v4                 => $nfs_v4,
    nfs_v4_idmap_domain    => $nfs_v4_idmap_domain,
    nfs_v4_kerberized      => $nfs_v4_kerberized,
    nfs_v4_kerberos_realm  => $nfs_v4_kerberos_realm,
    rpcgssd_opts           => $rpcgssd_opts,
    rpcsvcgssd_opts        => $rpcsvcgssd_opts,
    rpcidmapd_opts         => $rpcidmapd_opts,    
    rpcmountd_opts         => $rpcmountd_opts
  }

  include nfs::server::fedora::install, nfs::server::fedora::service


}

class nfs::server::fedora::install {
  package { 'nfs4-acl-tools':
    ensure => installed,
  }
}


class nfs::server::fedora::service {
  if !defined(Service['nfs-server']) {
    service { 'nfs-server':
        provider   => 'systemd',
        name       => 'nfs-server',
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["nfs-utils"],
        subscribe  => [ Concat['/etc/exports'], File['/etc/idmapd.conf'], File['/etc/sysconfig/nfs'] ],
      }
    }
}
