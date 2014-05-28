class nfs::server::redhat(
  $nfs_v4              = false,
  $nfs_v4_idmap_domain = undef,
  $manage_service      = $::nfs::server::nfs_manage_service,
) inherits nfs::server {

  class{ 'nfs::client::redhat':
    nfs_v4              => $nfs_v4,
    nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
  }

  include nfs::server::redhat::install

  $do_manage_service = str2bool($manage_service)
  if $do_manage_service {
    include nfs::server::redhat::service
  }
}
