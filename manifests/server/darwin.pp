class nfs::server::darwin(
  $nfs_v4 = false,
  $nfs_v4_idmap_domain = undef,
  $nfs_manage_service = $::nfs::server::nfs_manage_service,
) inherits nfs::server {
  fail("NFS server is not supported on Darwin")
}
