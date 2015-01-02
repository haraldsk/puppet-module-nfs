class nfs::params (
  $nfs_v4 = false,
  $nfs_v4_secure = false,
  $nfs_v4_export_root = '/export',
  $nfs_v4_export_root_clients  = "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
  $nfs_v4_mount_root  = '/srv',
  $nfs_v4_idmap_domain = $::domain
) {

  # ::osfamily fact doesnt exist with older facter versions (before 1.6.5 AFAIR)

  $domain = $::domain

  if $::osfamily == undef {
    case $::operatingsystem {
      'centos', 'redhat', 'scientific', 'fedora', 'OracleLinux' : {
        $osfamily = 'redhat'
        $package_name = 'nfs-utils'
        $service_name = 'nfs'
      } 'debian', 'Ubuntu': {
        $osfamily = 'debian'
        $package_name = 'nfs-kernel-server'
        $service_name = 'nfs-kernel-server'
      } 'windows': {
        fail('fail!11')
      } 'darwin':{
        $osfamily = 'darwin'
      } 'gentoo': {
        $osfamily = 'gentoo'
        $service_name = 'nfs'
      } default: {
        fail("OS: ${::operatingsystem} not supported")
      }
    }
  }
}
