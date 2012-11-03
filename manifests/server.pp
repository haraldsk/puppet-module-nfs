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
# === Examples
#
#
#  class { nfs::server:
#    nfs_v4              => true,
#    # Generally parameters below have sane defaults.
#    nfs_v4_export_root  => "/export",
#    nfs_v4_idmap_domain => "dom.ain"
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
  $nfs_v4                       = $nfs::params::nfs_v4,
  $nfs_v4_export_root           = $nfs::params::nfs_v4_export_root,
  $nfs_v4_export_root_clients   = $nfs::params::nfs_v4_export_root_clients,
  $nfs_v4_idmap_domain          = $nfs::params::domain,
) inherits nfs::params {


  $osfamily = downcase($::osfamily)
  if $osfamily in ['redhat', 'debian'] {
      class{ "nfs::server::${osfamily}":
        nfs_v4              => $nfs_v4,
        nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
      }
  } else {
    fail("Osfamliy: ${osfamily} not supported")
  }

  include  nfs::server::configure
}

class nfs::server::configure {

  if $nfs::server::nfs_v4 == true {
    file {
      "${nfs::server::nfs_v4_export_root}":
        ensure => directory,
    }
  }

  concat {'/etc/exports':
    notify => Service['nfs-kernel-server', 'portmap']
  }
  concat::fragment{
    'header':
      target  => '/etc/exports',
      content => "# This file is configured through the nfs::server puppet module\n",
      order   => 01;
    'root':
      target  => '/etc/exports',
      content => "${nfs::server::nfs_v4_export_root} ${nfs::server::nfs_v4_export_root_clients}\n",
      order   => 02
  }
}

