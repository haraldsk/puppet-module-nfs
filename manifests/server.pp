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

  include nfs::install, nfs::server::configure
}

class nfs::server::configure {

  if $nfs::server::nfs_v4 == true {
    include nfs::server::configure::nfs_v4::enabled
  } else {
    include nfs::server::configure::nfs_v4::disabled
  }

  service {
    ['portmap', 'nfs-kernel-server']:
      ensure => running,
  }
  concat {"/etc/exports":
    notify => Service['nfs-kernel-server', 'portmap']
  }
  concat::fragment{
    "header":
      target  => '/etc/exports',
      content => "# This file is configured through the nfs::server puppet module\n",
      order   => 01;
    "root":
      target  => '/etc/exports',
      content => "${nfs::server::nfs_v4_export_root} ${nfs::server::nfs_v4_export_root_clients}\n",
      order   => 02
  }
}

class nfs::server::configure::nfs_v4::enabled {

  class { nfs::configure::nfs_v4::enabled:
    nfs_v4_idmap_domain => $nfs::server::nfs_v4_idmap_domain,
  }

  file {
    "${nfs::server::nfs_v4_export_root}":
      ensure => directory,
  }

}


class nfs::server::configure::nfs_v4::disabled {

  include nfs::configure::nfs_v4::disabled
}

define nfs::server::export (
  $v3_export_name = $name,
  $v4_export_name = regsubst($name, '.*/(.*)', '\1' ),
  $clients = 'localhost(ro)') {

    # fail("v4_export_name: $v4_export_name")
    include nfs

    if $nfs::server::nfs_v4 {
      nfs::server::export::nfs_v4::bindmount { 
      "${name}": 
        v4_export_name => "${v4_export_name}" 
      }

      nfs::server::export::configure{
        "${nfs::server::nfs_v4_export_root}/${v4_export_name}":
          clients => $clients,
      }
      @@nfs::client::mount {"shared ${v4_export_name} by $::clientcert":
        ensure => 'present',
        share  => "${v4_export_name}",
        server => "$::clientcert",
      }
    } else {
      nfs::server::export::configure{
        "${v3_export_name}":
          clients => $clients,

      }

      @@nfs::client::mount {"shared ${v3_export_name} by $::clientcert":
        ensure => 'present',
        share  => "${v3_export_name}",
        server => "$::clientcert",
      }
    }
  }

  define nfs::server::export::configure ($clients) {

    $line = "${name} ${clients}\n"

    concat::fragment{
      "${name}":
        target  => '/etc/exports',
        content => "${line}"
    }
  }

  define nfs::server::export::nfs_v4::bindmount ( $v4_export_name ) {

    $expdir = "${nfs::server::nfs_v4_export_root}/$v4_export_name"

    nfs::mkdir{"${expdir}": }

    mount {
      "${expdir}":
        ensure  => mounted,
        device  => "${name}",
        atboot  => true,
        fstype  => 'none',
        options => 'bind',
        #require => Exec["mkdir_recurse_${expdir}"],
        require => Nfs::Mkdir["${expdir}"],
    }

  }

