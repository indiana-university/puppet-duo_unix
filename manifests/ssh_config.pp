# This class sets values in the sshd config file.
# Specifically:
#   * ForceCommand       /usr/sbin/login_duo
#   * PermitTunnel       no
#
# @summary This command sets ssh up to require duo through ForceCommand
#
# @example
#   include duo_unix::ssh_config
class duo_unix::ssh_config inherits duo_unix::params
{
  augeas { 'duo_ssh':
    context => '/files/etc/ssh/sshd_config',
    changes => [
      'set ForceCommand /usr/sbin/login_duo',
      'set PermitTunnel no',
    ],
    require => Package[$duo_unix::params::duo_package],
    notify  => Service[$duo_unix::params::ssh_service],
  }

  if !defined(Service[$duo_unix::params::ssh_service]) {
    service { $duo_unix::params::ssh_service:
      ensure => 'running'
    }
  }
}
