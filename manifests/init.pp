# == Class: nfsserver
#
# Full description of class nfsserver here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { nfsserver:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#

class nfsserver (
  $nfs_v4 = false,
  $nfs_v4_export_root = "/export",
  $idmap_domain = $::domain
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
      changes => ["set Domain $nfsserver::idmap_domain"],
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

