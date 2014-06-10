# == Class: nfs::server
#
# Set up NFS server and exports. NFSv3 and NFSv4 supported.
#
#
# === Parameters
#
# [nfs_v4]
#   NFSv4 support. Will set up automatic bind mounts to export root.
#   Disabled by default.
#
# [nfs_v4_export_root]
#   Export root, where we bind mount shares, default /export
#
# [nfs_v4_idmap_domain]
#  Domain setting for idmapd, must be the same across server
#  and clients.
#  Default is to use $domain fact.
#
# === Examples
#
#
#  class { nfs::server:
#    nfs_v4                      => true,
#     nfs_v4_export_root_clients => "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
#    # Generally parameters below have sane defaults.
#    nfs_v4_export_root  => "/export",
#    nfs_v4_idmap_domain => $::domain,
#  }
#
# === Authors
#
# Harald Skoglund <haraldsk@redpill-linpro.com>
#
# === Copyright
#
# Copyright 2012 Redpill Linpro, unless otherwise noted.
#

class nfs::server (
  $nfs_v4                       = $nfs::params::nfs_v4,
  $nfs_v4_export_root           = $nfs::params::nfs_v4_export_root,
  $nfs_v4_export_root_clients   = $nfs::params::nfs_v4_export_root_clients,
  $nfs_v4_idmap_domain          = $nfs::params::domain,

  $nfs_v4_root_export_ensure    = 'mounted',
  $nfs_v4_root_export_mount     = undef,
  $nfs_v4_root_export_remounts  = false,
  $nfs_v4_root_export_atboot    = false,
  $nfs_v4_root_export_options   = '_netdev',
  $nfs_v4_root_export_bindmount = undef,
  $nfs_v4_root_export_tag       = undef,
  $rquotad_port                 = 875,
  $lockd_tcpport                = 32803,
  $lockd_udpport                = 32769,
  $mountd_port                  = 892,
  $statd_port                   = 662,
  $statd_outgoing_port          = 2020,
) inherits nfs::params {

  class{ "nfs::server::${osfamily}":
    nfs_v4              => $nfs_v4,
    nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
    rquotad_port        => $rquotad_port,
    lockd_tcpport       => $lockd_tcpport,
    lockd_udpport       => $lockd_udpport,
    mountd_port         => $mountd_port,
    statd_port          => $statd_port,
    statd_outgoing_port => $statd_outgoing_port,
  }

  include  nfs::server::configure

  if defined(Class['firewall']) {
    firewall { "120 nfs tcp 111":
      proto => 'tcp',
      state => 'NEW',
      dport => '111',
      action => 'accept',
    }
    firewall { "120 nfs udp 111":
      proto => 'udp',
      dport => '111',
      action => 'accept',
    }
    firewall { "120 nfs tcp 2049":
      proto => 'tcp',
      state => 'NEW',
      dport => '2049',
      action => 'accept',
    }
    firewall { "120 nfs lockd_tcpport ${lockd_tcpport}":
      proto  => 'tcp',
      state  => 'NEW',
      dport  => $lockd_tcpport,
      action => 'accept',
    }
    firewall { "120 nfs lockd_udpport ${lockd_udpport}":
      proto  => 'udp',
      dport  => $lockd_udpport,
      action => 'accept',
    }
    firewall { "120 nfs mountd_port tcp ${mountd_port}":
      proto  => 'tcp',
      state  => 'NEW',
      dport  => $mountd_port,
      action => 'accept',
    }
    firewall { "120 nfs mountd_port udp ${mountd_port}":
      proto  => 'udp',
      dport  => $mountd_port,
      action => 'accept',
    }
    firewall { "120 nfs rquotad_port tcp ${rquotad_port}":
      proto  => 'tcp',
      state  => 'NEW',
      dport  => $rquotad_port,
      action => 'accept',
    }
    firewall { "120 nfs rquotad_port udp ${rquotad_port}":
      proto  => 'udp',
      dport  => $rquotad_port,
      action => 'accept',
    }
    firewall { "120 nfs statd_port tcp ${statd_port}":
      proto  => 'tcp',
      state  => 'NEW',
      dport  => $statd_port,
      action => 'accept',
    }
    firewall { "120 nfs statd_port udp ${statd_port}":
      proto  => 'udp',
      dport  => $statd_port,
      action => 'accept',
    }
  }
}
