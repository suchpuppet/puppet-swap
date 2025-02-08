# swap Puppet Module

## Overview

The `swap` module manages swap files on Linux systems, ensuring that swap space is properly configured and enabled via Puppet.

## Supported Platforms

- CentOS 7, 8, 9
- Red Hat Enterprise Linux 7, 8, 9
- Oracle Linux 7, 8
- Debian 10, 11, 12
- Ubuntu 18.04, 20.04, 22.04, 24.04

## Dependencies

This module depends on:

- puppetlabs/stdlib

## Usage

### Basic Usage

To configure a swap file with default settings:

```puppet
include swap
```

### Custom Swap File Size

To specify a custom swap file size (e.g., 4GB):

```puppet
class { 'swap':
  size_mb => 4096,
}
```

### Enabling or Disabling Swap

To explicitly enable or disable swap management:

```puppet
class { 'swap':
  enable => false,
}
```

## Parameters

| Parameter  | Type    | Default     | Description                             |
| ---------- | ------- | ----------- | --------------------------------------- |
| `enable`   | Boolean | `true`      | Whether swap should be enabled.         |
| `size_mb`  | Integer | `2048`      | The size of the swap file in megabytes. |
| `swapfile` | String  | `/swapfile` | The path of the swap file.              |

## Implementation Details

The module:

- Creates a swap file using `dd`.
- Updates `/etc/fstab` using the `file_line` resource.
- Enables swap with `swapon` and `mkswap`.

## Testing

To run unit tests with PDK:

```sh
pdk test unit
```

## License

This module is licensed under the Apache License, Version 2.0.
