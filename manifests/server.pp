# == Class: nfs::server
#
# Set up NFS server and exports. NFSv3 and NFSv4 supported.
#
#
# === Parameters
#
# [nfs_v4]
#   NFSv4 support. Will set up automatic bind mounts to export root.
#   Disabled by default.
#
# [nfs_v4_export_root]
#   Export root, where we bind mount shares, default /export
#
# [nfs_v4_idmap_domain]
#  Domain setting for idmapd, must be the same across server
#  and clients.
#  Default is to use $domain fact.
#
# [nfs_v4_kerberized]
#  (RHEL only) Toggles SECURE_NFS in /etc/sysconfig/nfs;
#  enables and runs rpc.gssd and rpc.svgssd
#
# [nfs_v4_kerberos_realm]
#  (RHEL only) For /etc/idmapd.conf's Local-Realms parameter.
#
# [rpcgssd_opts]
#  (RHEL only) Passes options to rpc.gssd in /etc/sysconfig/nfs.
#
# [rpcsvcgssd_opts]
#  (RHEL only) Passes options to rpc.svcgssd in /etc/sysconfig/nfs.
#
# [rpcidmapd_opts]
#  (RHEL only) Passes options to rpc.idmapd in /etc/sysconfig/nfs.
#
# [rpcmountd_opts]
#  (RHEL only) Passes options to rpc.mountd in /etc/sysconfig/nfs.
# 
#
# === Examples
#
#
#  class { nfs::server:
#    nfs_v4                 => true,
#    nfs_v4_kerberos_realm  => 'EXAMPLE.COM',
#    nfs_v4_kerberized      => true,
#    rpcgssd_opts	    => '-v',
#    rpcsvcgssd_opts        => '-v',
#    rpcidmapd_opts         => '-v',
#     nfs_v4_export_root_clients => "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
#    # Generally parameters below have sane defaults.
#    nfs_v4_export_root  => "/export",
#    nfs_v4_idmap_domain => $::domain,
#  }
#
# === Authors
#
# Harald Skoglund <haraldsk@redpill-linpro.com>
#
# === Copyright
#
# Copyright 2012 Redpill Linpro, unless otherwise noted.
#

class nfs::server (
  $nfs_v4                      = $nfs::params::nfs_v4,
  $nfs_v4_export_root          = $nfs::params::nfs_v4_export_root,
  $nfs_v4_export_root_clients  = $nfs::params::nfs_v4_export_root_clients,
  $nfs_v4_idmap_domain         = $nfs::params::domain,
  $nfs_v4_kerberized           = $nfs::params::nfs_v4_kerberized,
  $nfs_v4_kerberos_realm       = $nfs::params::nfs_v4_kerberos_realm,
  $rpcgssd_opts                = $nfs::params::rpcgssd_opts,
  $rpcsvcgssd_opts             = $nfs::params::rpcsvcgssd_opts,
  $rpcidmapd_opts              = $nfs::params::rpcidmapd_opts,  
  $rpcmountd_opts              = $nfs::params::rpcmountd_opts,
  # 
  $nfs_v4_root_export_ensure    = 'mounted',
  $nfs_v4_root_export_mount     = undef,
  $nfs_v4_root_export_remounts  = false,
  $nfs_v4_root_export_atboot    = false,
  $nfs_v4_root_export_options   = '_netdev',
  $nfs_v4_root_export_bindmount = undef,
  $nfs_v4_root_export_tag       = undef
) inherits nfs::params {

  class{ "nfs::server::${lsbdistid}":
    nfs_v4                 => $nfs_v4,
    nfs_v4_idmap_domain    => $nfs_v4_idmap_domain,
    nfs_v4_kerberized      => $nfs_v4_kerberized,
    nfs_v4_kerberos_realm  => $nfs_v4_kerberos_realm,
    rpcgssd_opts           => $rpcgssd_opts,
    rpcsvcgssd_opts        => $rpcsvcgssd_opts,
    rpcidmapd_opts         => $rpcidmapd_opts,
    rpcmountd_opts         => $rpcmountd_opts
  }

  include nfs::server::configure
}
