# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::rhel::install {

  Package {
    before => Class['nfs::client::rhel::configure']
  }
  package { 'nfs-utils':
    ensure => present,
  }

  if $nfs::client::rhel::osmajor == 6 {
    package {'rpcbind':
      ensure => present,
    }
  }
  elsif $nfs::client::rhel::osmajor == 5 {
    package { 'portmap':
      ensure => present,
    }
  }

  if $nfs::client::rhel::nfs_v4_kerberized {
    package { ['krb5-libs', 'krb5-workstation', 'krb5-devel',]:
      ensure => present,
    }    
  }
}

