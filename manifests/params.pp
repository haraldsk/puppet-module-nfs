class nfs::params (
  $nfs_v4 = false,
  $nfs_v4_export_root = '/export',
  $nfs_v4_export_root_clients  = "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
  $nfs_v4_mount_root  = '/srv',
  $nfs_v4_idmap_domain = $::domain
) {

  # Somehow the ::osfamliy fact doesnt exist on some oled systems

  case $::operatingsystem {
    'centos', 'redhat', 'scientific', 'fedora': {
      $osfamily = 'redhat'
    } 'debian', 'Ubuntu': {
      $osfamily = 'debian'
    } 'windows': {
      fail('fail!11')
    } default: {
      fail("OS: ${::operatingsystem} not supported")
    }
  }

  case $::lsbdistcodename {
    'lucid': {
      $portmap_service = 'portmap'
      $portmap_package = 'portmap'
    }
    'precise': {
      $portmap_service = 'portmap'
      $portmap_package = 'portmap'
    }
    default: {
      $portmap_service = 'rpcbind'
      $portmap_package = 'rpcbind'
    }
  }

}
