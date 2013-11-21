# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::redhat::configure {

  if $nfs::client::redhat::nfs_v4 {
    if $nfs::client::redhat::nfs_v4_secure {
      $nfsv4secure = 'yes'
    } else {
      $nfsv4secure = 'no'
    }
    augeas {
      '/etc/sysconfig/nfs':
        context => '/files/etc/sysconfig/nfs',
        lens    => 'Sysconfig.lns',
        incl    => '/etc/sysconfig/nfs',
        changes => [ "set SECURE_NFS $nfsv4secure", ];
      '/etc/idmapd.conf':
        context => '/files/etc/idmapd.conf/General',
        lens    => 'Puppet.lns',
        incl    => '/etc/idmapd.conf',
        changes => ["set Domain ${nfs::client::redhat::nfs_v4_idmap_domain}"],
    }
  }
}
