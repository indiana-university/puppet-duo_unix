# Changelog
## Release 4.2.4
* Fixes idempotency in ssh_config and adds sshd_config_path as a params default.

## Release 4.2.3
* Writes sshd config to file in sshd_config.d instead of sshd_config file

## Release 4.2.2
* Major change that should have coincided with 4.2.0: changing the use of augeas in favor of stdlib's file_line resource.

## Release 4.2.1
* Resolves dependency issues

## Release 4.2.0
* Adds duo_rsyslog option to the module - when activated, it sends Duo's syslog messages into the OS default auth log (also helpful for fail2ban use cases)

## Release 4.1.0
* Adds pdk auto-added .config directory to gitignore
* Format linting on manifests/ssh_config.pp
* Adds 'with accept_env_factor => yes' context to spec/classes/duo_unix_spec.rb, to test when yes is specified for that class
* Adds jammy and noble Ubuntu releases to Duo repo setup
* Seemingly small but VERY significant changes to augeas blocks in manifests/ssh_config.pp to actually get this module to touch sshd_config at all, and to ensure idempotency when specifying an AcceptEnv option using Puppet's 'onlyif' f
eature (augeas was NOT designed to do conveniently this) 

## Release 4.0.3
* Accordingly updates sshd_config file if the accept_env_factor parameter is set to 'yes'

## Release 4.0.2
* Support Puppet 8, Drop Puppet 6, support stdlib 9.x

## Release 4.0.1
* PDK update
* Merge pull request for optional cafile parameter (treydock)

## Release 4.0.0
* Split ensure parameter to package_ensure and config_ensure
* Add reference file

## Release 3.0.0
* Fixed unit tests
* Fixed puppet-lint issues
* Updated legacy facts
* Updated PDK
* Updated DUO GPG keys
* Updated README
* Dropped Ubuntu 14.04 support
* Dropped Ubuntu 16.04 support
* Dropped CentOS 6 support
* Dropped Debian 8 support
* Dropped Debian 9 support
* Added Ubuntu 20.04 support
* Added CentOS 9 support
* Added RedHat 9 support
* Added Debian 11 support
* Removed deprecated `puppetlabs/translate` module

## Release 2.1.1
* Fixed some code quality issues

## Release 2.1.0
* Added initial support for Rocky and Alma Linux
  * They will be using the RedHat version of Puppet, not CentOS

## Release 2.0.0
* Removed older unsupported versions of various operating systems
  * This is why this is version 2x
* Switched how OS code name is derived on debian based systems
* Added some more documentation to the example

## Release 1.0.11
* Updated PPA pgp key fingerprint
* Bumped version of PDK

## Release 1.0.10
* Removed `AllowTcpForwarding no` as this conflicts in environments where the requirement for `AllowTcpForwarding` needs to be `yes`.
* Updated pdk
* Updated Changelog
* Updated Metadata.json
* Removed vscode extension

## Release 1.0.9
* scorgatelli-docutech added conditional repo management and fixed some bugs

## Release 1.0.8
* Changed ssh service name to 'sshd' on RedHat based systems

## Release 1.0.7
* Parameterize displaying diff
* Updated Yum Repo key
* Fix groups usage

## Release 1.0.6

* Updated pdk
* Updated dependency upbound limit in metadata.json

## Release 1.0.5

* Fixed my fix for the config template

## Release 1.0.4

**Bugfixes**

* Fixed issue where `group` and `http_proxy` were always set in the config even when blank

## Release 0.1.0

**Features**

**Bugfixes**

**Known Issues**
