define nfs::server::export (
  $v3_export_name = $name,
  $v4_export_name = regsubst($name, '.*/(.*)', '\1' ),
  $clients = 'localhost(ro)'
) {


  if $nfs::server::nfs_v4 {

    nfs::server::export::nfs_v4::bindmount {
    "${name}":
    v4_export_name => "${v4_export_name}"
    }

    nfs::server::export::configure{
      "${nfs::server::nfs_v4_export_root}/${v4_export_name}":
        clients => $clients,
        require => Nfs::Server::Export::Nfs_v4::Bindmount["${name}"]
    }

    @@nfs::client::mount {"shared ${v4_export_name} by ${::clientcert}":
      ensure => 'present',
      share  => "${v4_export_name}",
      server => "${::clientcert}",
    }

    } else {

    nfs::server::export::configure{
      "${v3_export_name}":
        clients => $clients,

    }

    @@nfs::client::mount {"shared ${v3_export_name} by ${::clientcert}":
      ensure => 'present',
      share  => "${v3_export_name}",
      server => "${::clientcert}",
    }
  }
}

define nfs::server::export::configure ($clients) {

  $line = "${name} ${clients}\n"

  concat::fragment{
    "${name}":
      target  => '/etc/exports',
      content => "${line}"
  }
}

define nfs::server::export::nfs_v4::bindmount ( $v4_export_name ) {

  $expdir = "${nfs::server::nfs_v4_export_root}/${v4_export_name}"

  nfs::mkdir{"${expdir}": }

  mount {
    "${expdir}":
      ensure  => mounted,
      device  => "${name}",
      atboot  => true,
      fstype  => 'none',
      options => 'bind',
      require => Nfs::Mkdir["${expdir}"],
  }

}

