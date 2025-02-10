# @summary Manages fstab entry for swap device
class swap::fstab {
  include swap

  if $swap::enable == false {
    augeas { 'remove_swap_from_fstab':
      context => '/files/etc/fstab',
      changes => [
        "rm *[file = '${swap::swap_device}']",
      ],
      onlyif  => "match *[file = '${swap::swap_device}'] size > 0",
    }
  } else {
    file_line { 'ensure_swap_in_fstab':
      ensure => present,
      path   => '/etc/fstab',
      line   => "${swap::swap_device} none swap sw 0 0",
      match  => "^${swap::swap_device}\\s+none\\s+swap\\s+.*",
    }
  }
}
