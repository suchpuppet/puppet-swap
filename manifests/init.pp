# Class: swap
#
# Manages swap space by creating, enabling, and configuring a swap file.
#
# @param [Boolean] enable
#   Whether swap management is enabled. Defaults to `true`.
#
# @param [Integer] swap_size_mb
#   The size of the swap file in megabytes. Defaults to `2048`.
#
# @param [String] swap_device
#   The path of the swap file. Defaults to `/swapfile`.
#
class swap (
  Boolean $enable,
  String $swap_device,
  Integer $swap_size_mb,
) {
  $ensure = $enable ? {
    false => 'absent',
    true  => 'present',
  }

  if $enable == false {
    exec { 'disable_swap':
      command  => 'swapoff -a',
      provider => 'shell',
      onlyif   => "grep ${swap_device} /proc/swaps",
    }
  } else {
    exec { 'create_swap_file':
      command  => "dd if=/dev/zero of=${swap_device} bs=1M count=${swap_size_mb}",
      provider => 'shell',
      creates  => $swap_device,
      before   => File[$swap_device],
    }

    file { $swap_device:
      ensure => $ensure,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
      before => Exec['format_swap'],
    }

    exec { 'format_swap':
      command  => "mkswap ${swap_device}",
      provider => 'shell',
      before   => Exec['enable_swap'],
    }

    exec { 'enable_swap':
      command  => "swapon ${swap_device}",
      provider => 'shell',
    }
  }

  mount { $swap_device:
    ensure  => $ensure,
    atboot  => true,
    device  => $swap_device,
    fstype  => 'swap',
    options => 'defaults',
  }
}
