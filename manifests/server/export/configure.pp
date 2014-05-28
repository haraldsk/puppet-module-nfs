define nfs::server::export::configure (
  $ensure = 'present',
  $clients
) {

  if $ensure != 'absent' {
    $line = sprintf("%s %s\n", $name, join($clients, " "))

    concat::fragment{
      "${name}":
        target  => '/etc/exports',
        content => "${line}"
    }
  }
}
