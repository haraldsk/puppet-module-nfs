# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::rhel::params {

  if versioncmp($::operatingsystemrelease, "6.0") > 0 {
    $osmajor = 6
  } elsif versioncmp($::operatingsystemrelease, "5.0") > 0 {
    $osmajor = 5
  }
}


