class nfs {

  include nfs::install


}

class nfs::install {

  case $::operatingsystem {

    'ubuntu', 'debian': {

      ensure_resource( 'package', 'nfs-kernel-server', { 'ensure' => 'installed' } )
      #ensure_resource( 'package', 'portmap',           { 'ensure' => 'installed' } )
      ensure_resource( 'package', 'nfs-common',        { 'ensure' => 'installed' } )
      ensure_resource( 'package', 'nfs4-acl-tools',    { 'ensure' => 'installed' } )
    }
    'redhat', 'centos', 'sles': {
      ensure_resource( 'package', 'nfs-utils',        { 'ensure' => 'installed' } )
      ensure_resource( 'package', 'rpcbind',          { 'ensure' => 'installed' } )
      ensure_resource( 'package', 'nfs4-acl-tools',   { 'ensure' => 'installed' } )
    }
    default: {
      fail("Not tested on $operatingsystem")
    }

  }

}

class nfs::configure::nfs_v4::enabled ( $nfs_v4_idmap_domain = $nfs::params::nfs_v4_idmap_domain ) {

  case $::operatingsystem {

    'ubuntu', 'debian': {

      augeas {
        '/etc/default/nfs-common':
          context => '/files/etc/default/nfs-common',
          changes => [ 'set NEED_IDMAPD yes', ],
          notify  => Service['nfs-kernel-server', 'idmapd' ];
        '/etc/idmapd.conf':
          context => '/files/etc/idmapd.conf/General',
          lens    => 'Puppet.lns',
          incl    => '/etc/idmapd.conf',
          changes => ["set Domain $nfs_v4_idmap_domain"],
          notify  => Service['nfs-kernel-server', 'idmapd' ]
      }

      service {
        'idmapd':
          ensure => running,
          notify => Service['nfs-kernel-server']
      }
    } 'redhat', 'centos', 'sles': {

      augeas {
        '/etc/idmapd.conf':
          context => '/files/etc/idmapd.conf/General',
          lens    => 'Puppet.lns',
          incl    => '/etc/idmapd.conf',
          changes => ["set Domain $nfs_v4_idmap_domain"],
          notify  => Service['nfs' ]
      }
    }
    default: {
      fail("Not tested on $operatingsystem")
    }
  }

}

class nfs::configure::nfs_v4::disabled {

  case $::operatingsystem {
    'ubuntu', 'debian': {
      service {
        'idmapd':
          ensure => stopped,
      }
    }
  }
}


define nfs::mkdir() {

  # Nasty ass hax to allow several levels of directories
  exec { "mkdir_recurse_${name}":
    path    => [ '/bin', '/usr/bin' ],
    command => "mkdir -p ${name}",
    unless  => "test -d ${name}",
  }

  file {
    "${name}":
      ensure  => directory,
      require => Exec["mkdir_recurse_${name}"]
  }

}
