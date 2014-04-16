class nfs::client::debian (
  $nfs_v4              =  $::nfs::client::nfs_v4,
  $nfs_v4_idmap_domain =  $::nfs::client::nfs_v4_idmap_domain,
  $nfs_v4_secure       =  $::nfs::client::nfs_v4_secure
) {

  include nfs::client::debian::install,
    nfs::client::debian::configure,
    nfs::client::debian::service
}
