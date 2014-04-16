class nfs::client::debian::configure {
  Augeas{
    require => Class['nfs::client::debian::install']
  }

  if $nfs::client::debian::nfs_v4 {
    if $nfs::client::debian::nfs_v4_secure {
      $needgssd = 'yes',
    } else {
      $needgssd = 'no'
    }
    augeas {
      '/etc/default/nfs-common':
        context => '/files/etc/default/nfs-common',
        changes => [ 'set NEED_IDMAPD yes',
                     "set NEED_GSSD $needgssd",
                     ];
      '/etc/idmapd.conf':
        context => '/files/etc/idmapd.conf/General',
        lens    => 'Puppet.lns',
        incl    => '/etc/idmapd.conf',
        changes => ["set Domain ${nfs::client::debian::nfs_v4_idmap_domain}"],
    }
  }
}
