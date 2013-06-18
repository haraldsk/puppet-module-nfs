class nfs::params (
  $nfs_v4 = false,
  $nfs_v4_export_root = '/export',
  $nfs_v4_export_root_clients  = "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
  $nfs_v4_mount_root  = '/srv',
  $nfs_v4_idmap_domain = $::domain,
  $nfs_v4_kerberos_realm = undef,
  $nfs_v4_kerberized = false,
  $rpcgssd_opts = undef,
  $rpcsvcgssd_opts = undef,
  $rpcidmapd_opts = undef,  
  $rpcmountd_opts = undef,  
  ) {

  # Somehow the ::lsbdistid fact doesn't exist on some old systems

  case $::operatingsystem {
    'centos', 'rhel', 'scientific': {
      $lsbdistid = 'rhel'
    }
    'fedora': {
      $lsbdistid = 'fedora'
    }
    'debian', 'Ubuntu': {
      $lsbdistid = 'debian'
    }
    'windows': {
      fail('fail!11')
    }
    default: {
      fail("OS: ${::operatingsystem} not supported")
    }
  }
}
