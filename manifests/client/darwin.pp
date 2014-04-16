class nfs::client::darwin (
  $nfs_v4              =  $::nfs::client::nfs_v4,
  $nfs_v4_idmap_domain =  $::nfs::client::nfs_v4_idmap_domain,
  $nfs_v4_secure       =  $::nfs::client::nfs_v4_secure

) {
  fail("NFS client is not supported on Darwin")
}
