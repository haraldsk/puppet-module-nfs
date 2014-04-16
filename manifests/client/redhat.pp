# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::redhat (
  $nfs_v4              =  $::nfs::client::nfs_v4,
  $nfs_v4_idmap_domain =  $::nfs::client::nfs_v4_idmap_domain,
  $nfs_v4_secure       =  $::nfs::client::nfs_v4_secure
) inherits nfs::client::redhat::params {

  include nfs::client::redhat::install,
    nfs::client::redhat::configure,
    nfs::client::redhat::service
}
