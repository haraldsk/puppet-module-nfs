class nfs::server::redhat(
  $nfs_v4                       = false,
  $nfs_v4_idmap_domain          = undef,
  $rquotad_port                 = 875,
  $lockd_tcpport                = 32803,
  $lockd_udpport                = 32769,
  $mountd_port                  = 892,
  $statd_port                   = 662,
  $statd_outgoing_port          = 2020,
) {

  class{ 'nfs::client::redhat':
    nfs_v4              => $nfs_v4,
    nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
  }

  include nfs::server::redhat::install, nfs::server::redhat::service


}
