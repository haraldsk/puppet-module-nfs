class nfs::client::debian::install {

  case $::operatingsystem  {
    'Ubuntu': {
      package { 'portmap':
        ensure => installed,
      }

      Service {'portmap': require => Package['portmap'] }

    } default: {
      package { 'rpcbind':
        ensure => installed,
      }

      Service {'portmap': require => Package['rpcbind'] }

    }
  }

  package { ['nfs-common', 'nfs4-acl-tools']:
    ensure => installed,
  }

}
