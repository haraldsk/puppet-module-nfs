class nfs::server::debian::install {

  package { 
    'nfs-common':
    ensure => installed;

    'portmap':
    ensure => installed;
  }

}
