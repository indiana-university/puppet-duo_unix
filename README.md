
# duo_unix

[![Build Status](https://travis-ci.org/indiana-university/puppet-duo_unix.svg?branch=master)](https://travis-ci.org/indiana-university/puppet-duo_unix)

The duo_unix module handles the deployment of duo_unix (`login_duo` or 
`pam_duo`) across a range of Linux distributions. The module will handle
repository dependencies, installation of the duo_unix package, configuration
of OpenSSH, and PAM alterations as needed.

For further information about duo_unix, view the official
[documentation](https://www.duosecurity.com/docs/duounix).

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with duo_unix](#setup)
    * [What duo_unix affects](#what-duo_unix-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with duo_unix](#beginning-with-duo_unix)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Contributing](#contributing)

## Description

The duo_unix Puppet module installs and manages duo_unix (login_duo or pam_duo).

This module is meant to be a drop-in replacement for the abandoned official 
puppet module.

## Setup

### What duo_unix affects

This module will add the official Duo Inc. repository. It will also then
install the appropriate package(s) for your system.

It will also optionally alter some files on your system to help ensure that user
login attempts will correctly require Duo to succeed.

If `usage` is set to `login`, it will set the following directives in
`/etc/ssh/sshd_config` 

```
ForceCommand       /usr/sbin/login_duo
PermitTunnel       no
AllowTcpForwarding no
```

If `usage` is set to `pam`, it will alter your pam config. Those changes are
distribution-specific. To see exactly what is changed, please refer to the
`manifests/pam_config.pp` file.

### Setup Requirements

This module requires some additional modules, but it is highly likely that they
are already installed on your puppet server. They are as follows:


* `puppetlabs/apt` `6.0 - 8.0`
* `puppetlabs/augeas_core` `1.0.0 - 2.0.0`
* `puppetlabs/stdlib` `5.0.0 - 6.0.0`
* `puppetlabs/translate` `1.0.0 - 3.0.0`
* `puppetlabs/yumrepo_core` `1.0.0 - 2.0.0`

### Beginning with duo_unix

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

```ruby
class { 'duo_unix':
  usage => 'login',
  ikey  => 'your integration key',
  skey  => 'your secret key',
  host  => 'api-yourhost.duosecurity.com',
  motd  => 'yes',
}
```

## Limitations

In the past the official Duo module supported various RedHat derivatives. This
module *currently* makes no attempt to support them.

## Contributing

Pull requests are welcome, but all code must meet the following requirements

* Is fully tested
* All tests *must* pass
* Follows the [Puppet language style guide](https://puppet.com/docs/puppet/latest/style_guide.html)
