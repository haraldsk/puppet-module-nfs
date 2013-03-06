define nfs::server::export::nfs_v4::bindmount ( 
  $ensure = 'mounted',
  $bind = $bind,
  $v4_export_name
) {

  $expdir = "${nfs::server::nfs_v4_export_root}/${v4_export_name}"

  nfs::mkdir{"${expdir}": }

  mount {
    "${expdir}":
      ensure  => $ensure,
      device  => "${name}",
      atboot  => true,
      fstype  => 'none',
      options => $bind,
      require => Nfs::Mkdir["${expdir}"],
  }

}
