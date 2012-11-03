class nfs::params {

  $nfs_v4 = false
  $nfs_v4_export_root = '/export'
  $nfs_v4_export_root_clients  = "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)"
  $nfs_v4_mount_root  = '/srv'
  $nfs_v4_idmap_domain = $::domain

}
