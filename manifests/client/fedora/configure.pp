# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::fedora::configure {

  # Because rhel/fedora /etc/sysconfig/nfs doesn't want true/false
  # it wants yes/no
  if $nfs::client::fedora::nfs_v4_kerberized {
     $nfs_v4_secure = 'yes'
  } else {
     $nfs_v4_secure = 'no'
  }

  concat { '/etc/idmapd.conf':
    warn    => true,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
  concat { '/etc/sysconfig/nfs':
    warn    => true,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
  concat::fragment { 'idmapd.conf.erb':
    target  => '/etc/idmapd.conf',
    order   => 01,
    content => template('nfs/idmapd.conf.erb'),
    notify  => Service['nfs-idmap'],
  }

  # yes, the old /etc/init.d/nfs is called nfs-server now
  # no, there is no nfs-client on Fedora 17+
  concat::fragment { 'rhel-sysconfig-nfs':
    target  => '/etc/sysconfig/nfs',
    order   => 02,
    content => template('nfs/rhel-sysconfig-nfs.erb'),
    notify  => Service['nfs-secure', 'nfs-idmap', 'nfs-server'],
  }  
}
