# Nasty ass hax to allow several levels of directories
# Ensures the directory exists in the catalag
define nfs::mkdir() {
    if ! defined (File[$name]) {
        exec { "mkdir_recurse_${name}" :
            path    => [ '/bin', '/usr/bin' ],
            command => "mkdir -p ${name}",
            unless  => "test -d ${name}",
        }

        file { $name :
            ensure  => directory,
            require => Exec["mkdir_recurse_${name}"]
        }
    }
}