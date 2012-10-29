# == Class: nfsserver
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
#  class { nfsserver:
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

class nfsserver (
  $nfs_v4 = false,
  $nfs_v4_export_root = "/export",
  $nfs_v4_idmap_domain = $::domain
) {

  include nfsserver::install
  include nfsserver::configure
}

class nfsserver::install {

  case $operatingsystem {

    'ubuntu', 'debian': {
      package {
        [ 'nfs-kernel-server', 'nfs-common', 'nfs4-acl-tools' ]:
          ensure => present,
      }
    }
    'redhat', 'centos', 'sles': {
      package {
        [ 'nfs-utils', 'nfs4-acl-tools' ]:
          ensure => present,
      }
    }
    default: {
     fail("Not tested on $operatingsystem")
    }

  }

}

class nfsserver::configure {

  if $nfsserver::nfs_v4 == true {
    include nfsserver::configure::nfs_v4::enabled
    } else {
      include nfsserver::configure::nfs_v4::disabled
    }

    service {
      'nfs-kernel-server':
        ensure => running,
    }
    concat {"/etc/exports":
      notify => Service["nfs-kernel-server"]
    }
}

class nfsserver::configure::nfs_v4::enabled {

  augeas {
    '/etc/default/nfs-common':
      context => '/files/etc/default/nfs-common',
      changes => [ 'set NEED_IDMAPD yes', ],
      notify  => Service['nfs-kernel-server', 'idmapd' ];
    '/etc/idmapd.conf':
      context => '/files/etc/idmapd.conf/General',
      lens    => 'Puppet.lns',
      incl    => '/etc/idmapd.conf',
      changes => ["set Domain $nfsserver::nfs_v4_idmap_domain"],
      notify  => Service['nfs-kernel-server', 'idmapd' ]
  }

  file {
    "${nfsserver::nfs_v4_export_root}":
      ensure => directory,
  }

  service {
    'idmapd':
      ensure    => running,
      notify => Service['nfs-kernel-server']
  }
}


class nfsserver::configure::nfs_v4::disabled {

  service {
    'idmapd':
      ensure => stopped,
  }
}

define nfsserver::export (
  $v4_export_name = regsubst($name, '.*/(.*)', '\1' ),
  $clients = 'localhost(ro)') {

  if $nfsserver::nfs_v4 {
    nfsserver::export::nfs_v4::bindmount { 
      "${name}": 
        v4_export_name => "${v4_export_name}" 
    }

    nfsserver::export::configure{
      "${nfsserver::nfs_v4_export_root}/${v4_export_name}":
        clients => $clients,
    }
  } else {
    fail("Remember to fix nfs3")
  }
}

define nfsserver::export::configure ($clients) {

  $line = "${name} ${clients}\n"

  concat::fragment{
    "${name}":
      target  => '/etc/exports',
      content => "${line}"
  }
}

define nfsserver::export::nfs_v4::bindmount ( $v4_export_name ) {

  $expdir = "${nfsserver::nfs_v4_export_root}/$v4_export_name"

  # Nasty ass hax to allow several levels of directories
  exec { "mkdir_recurse_${expdir}":
    path    => [ '/bin', '/usr/bin' ],
    command => "mkdir -p ${expdir}",
    unless => "test -d ${expdir}",
  }

  mount {
    "${expdir}":
      ensure  => mounted,
      device  => "${name}",
      atboot  => true,
      fstype  => 'none',
      options => 'bind',
      require => Exec["mkdir_recurse_${expdir}"],
  }

}

