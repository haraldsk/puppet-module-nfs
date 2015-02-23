class nfs::client::debian::install {

  case $::operatingsystem  {
    'Ubuntu': {     # Valid for version after lucid 
      package { 'portmap':
        ensure => installed,
      }

     Package['portmap'] ->  Service ['portmap']

    } default: {
      package { 'rpcbind':
        ensure => installed,
      }

     Package['rpcbind'] -> Service ['portmap']

    }
  }

  package { ['nfs-common', 'nfs4-acl-tools']:
    ensure => installed,
  }

}
