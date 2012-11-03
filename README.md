puppet-module-nfs - For all your NFS Needs
=======================

Puppet module for setting up nfsserver and clients.

Storeconfigs is used for propogating export configs
to clients.

Optional nfs4-support.

----------------------
Dependencies
----------------------

Puppetmaster must be configured to use storeconfigs.
Clients need to support augeas.

Check Modulesfile for module dependencies


----------------------
Examples
----------------------

Simple NFSv3 server and client example::
  
  node server {
    include nfs::server
    nfs::server::export{ '/data_folder':
      ensure  => 'present',
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash) localhost(rw)'
  }

  node client {
    include nfs::client
    Nfs::Server::Mount<<| |>>
  }

