# This class sets values in the sshd config file.
# Specifically:
#   * ForceCommand       /usr/sbin/login_duo
#   * PermitTunnel       no
#   * AcceptEnv          DUO_PASSCODE  #This is only if accept_env_factor is set to 'yes'
#
# @summary This command sets ssh up to require duo through ForceCommand
#
# @example
#   include duo_unix::ssh_config
class duo_unix::ssh_config inherits duo_unix::params {
  augeas { 'duo_ssh':
    lens    => 'Sshd.lns',
    incl    => '/etc/ssh/sshd_config',
    changes => [
      'set /files/etc/ssh/sshd_config/ForceCommand /usr/sbin/login_duo',
      'set /files/etc/ssh/sshd_config/PermitTunnel no',
    ],
    require => Package[$duo_unix::params::duo_package],
    notify  => Service[$duo_unix::params::ssh_service],
  }
# If the env factor is set to yes, creates idempotency for AcceptEnv in augeas block with onlyif that
# looks for pre-existing DUO_PASSCODE because even though it seems so, augeas wasn't designed for idempotency
  if $duo_unix::params::accept_env_factor == 'yes' {
    augeas { 'duo_ssh_env':
      lens    => 'Sshd.lns',
      incl    => '/etc/ssh/sshd_config',
      changes => [
        'set /files/etc/ssh/sshd_config/AcceptEnv[1000]/01 DUO_PASSCODE',
      ],
      require => Package[$duo_unix::params::duo_package],
      notify  => Service[$duo_unix::params::ssh_service],
      onlyif  => "values /files/etc/ssh/sshd_config/AcceptEnv/* not_include 'DUO_PASSCODE'",
    }
  }

  if !defined(Service[$duo_unix::params::ssh_service]) {
    service { $duo_unix::params::ssh_service:
      ensure => 'running',
    }
  }
}
