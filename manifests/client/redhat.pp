# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::redhat (
  $nfs_v4              =  $::nfs::client::nfs_v4,
  $nfs_v4_idmap_domain =  $::nfs::client::nfs_v4_idmap_domain,
  $manage_service      = true,
) inherits nfs::client::redhat::params {

  include nfs::client::redhat::install
  include nfs::client::redhat::configure

  $do_manage_service = str2bool($manage_service)
  if $do_manage_service {
    include nfs::client::redhat::service
  }
}
