# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::fedora::install {

  Package {
    before => Class['nfs::client::fedora::configure']
  }
  package { 'nfs-utils':
    ensure => present,
  }
  package {'rpcbind':
      ensure => present,
  }

  if $nfs::client::fedora::nfs_v4_kerberized {
    package { ['krb5-libs', 'krb5-workstation', 'krb5-devel',]:
      ensure => present,
    }    
  }
}

