# @summary This command sets ssh up to require duo through ForceCommand
#
# @example
#   include duo_unix::ssh_config
class duo_unix::ssh_config inherits duo_unix::params {
  $sshd_config_path = '/etc/ssh/sshd_config.d/99-duo_sshd.conf'
  file { $sshd_config_path:
    content => "ForceCommand /usr/sbin/login_duo\nPermitTunnel no",
    notify  => Service[$duo_unix::params::ssh_service],
    require => Package[$duo_unix::params::duo_package],
  }
  if $duo_unix::accept_env_factor == 'yes' {
    file_line { 'acceptenv_duo_passcode':
      path    => $sshd_config_path,
      line    => 'AcceptEnv DUO_PASSCODE',
      notify  => Service[$duo_unix::params::ssh_service],
      require => Package[$duo_unix::params::duo_package],
    }
  }
  if !defined(Service[$duo_unix::params::ssh_service]) {
    service { $duo_unix::params::ssh_service:
      ensure => 'running',
    }
  }
}
