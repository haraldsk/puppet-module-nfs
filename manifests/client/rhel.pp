# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::rhel (
  $nfs_v4 = false,
  $nfs_v4_idmap_domain = undef,
  $nfs_v4_kerberized = false,
  $nfs_v4_kerberos_realm = undef,
  $rpcgssd_opts = undef,
  $rpcsvcgssd_opts = undef,
  $rpcidmapd_opts = undef,
  $rpcmountd_opts = undef

  
) inherits nfs::client::rhel::params {

  include nfs::client::rhel::install, 
    nfs::client::rhel::configure, 
    nfs::client::rhel::service
}
