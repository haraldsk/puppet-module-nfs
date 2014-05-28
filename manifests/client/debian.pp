class nfs::client::debian (
  $nfs_v4              =  $::nfs::client::nfs_v4,
  $nfs_v4_idmap_domain =  $::nfs::client::nfs_v4_idmap_domain,
  $manage_service      = true,
) {

  include nfs::client::debian::install
  include nfs::client::debian::configure

  $do_manage_service = str2bool($manage_service)
  if $do_manage_service {
    include nfs::client::debian::service
  }
}
