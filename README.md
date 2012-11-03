puppet-module-nfs - For all your NFS Needs
=======================

Puppet module for setting up nfsserver and clients.

Storeconfigs is used for propogating export configs
to clients.

Optional nfs4-support.

Dependencies
----------------------

Puppetmaster must be configured to use storeconfigs.
Clients need to support augeas.

Check Modulesfile for module dependencies


Examples
----------------------

=== Simple NFSv3 server and client example

This will export /data/folder on the server and automagically mount it on client.
  
<pre>
  node server {
    include nfs::server
    nfs::server::export{ '/data_folder':
      ensure  => 'mounted',
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash) localhost(rw)'
  }

  # By default, mounts are mounted in the same folder on the clients as
  # they were exported from on the server
  node client {
    include nfs::client
    Nfs::Server::Mount &lt;&lt;| | &lt;&lt; 
  }

</pre>


=== NFSv3 multiple exports, servers and multiple node example

  
<pre>
  node server1 {
    include nfs::server
    nfs::server::export{ 
      '/data_folder':
        ensure  => 'mounted',
        clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash) localhost(rw)'
      # exports /homeexports and mounts them om /srv/home on the clients
      '/homeexport':
        ensure  => 'mounted',
        clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,root_squash)',
        mount   => '/srv/home'
  }

  node server2 {
    include nfs::server
    # ensure is passed to mount, which will make the client not mount it
    # the directory automatically, just add it to fstab
    nfs::server::export{ 
      '/media_library':
        ensure  => 'present',
        tag     => 'media'
        clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash) localhost(rw)'
  }

  node client {
    include nfs::client
    Nfs::Server::Mount < < | | > >
  }

  # Using a storeconfig override, to change ensure option, so we mount
  # all shares
  node greedy_client {
    include nfs::client
    Nfs::Server::Mount < < | | > > {
      ensure => 'mounted'
    }
  }


  # only the mount tagged as media 
  # also override mount point
  node media_client {
    include nfs::client
    Nfs::Server::Mount < < | tag == 'media' | > > {
      ensure => 'mounted',
      mount  => '/import/media'
    }
  }

  # All @@nfs::server::mount storeconfigs can be filtered by parameters
  # Also all parameters can be overridden (not that it's smart to do
  # so).
  # Check out the doc on exported resources for more info:
  # http://docs.puppetlabs.com/guides/exported_resources.html
  node single_server_client {
    include nfs::client
    Nfs::Server::Mount < < | server == 'server1' | > > {
      ensure => 'absent',
    }
  }

</pre>
