class nfs::client::debian::install {

  case $::operatingsystem  {
    'Ubuntu': {
      package { 'portmap':
        ensure => installed,
      }
    } default: {
      package { 'rpcbind':
        ensure => installed,
      }
    }
  }

  package { ['nfs-common', 'nfs4-acl-tools']:
    ensure => installed,
  }

}
