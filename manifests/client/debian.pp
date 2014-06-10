class nfs::client::debian (
  $nfs_v4 = false,
  $nfs_v4_idmap_domain = undef
) {

  include nfs::client::debian::install,
    nfs::client::debian::configure,
    nfs::client::debian::service

  anchor{ 'nfs::client::debian::start': }
  ->
  Class['nfs::client::debian::install']
  ->
  Class['nfs::client::debian::configure']
  ->
  Class['nfs::client::debian::service']
  ->
  anchor{ 'nfs::client::debian::end': }
}
