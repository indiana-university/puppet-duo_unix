# @summary This command sets ssh up to require duo through ForceCommand
#
# @example
#   include duo_unix::ssh_config
class duo_unix::ssh_config inherits duo_unix::params {
  if ($duo_unix::accept_env_factor == 'yes') {
    $sshd_config_contents = "ForceCommand /usr/sbin/login_duo\nPermitTunnel no\nAcceptEnv DUO_PASSCODE"
  } else {
    $sshd_config_contents = "ForceCommand /usr/sbin/login_duo\nPermitTunnel no"
  }
  file { $duo_unix::params::sshd_config_path:
    content => $sshd_config_contents,
    notify  => Service[$duo_unix::params::ssh_service],
    require => Package[$duo_unix::params::duo_package],
  }
  if !defined(Service[$duo_unix::params::ssh_service]) {
    service { $duo_unix::params::ssh_service:
      ensure => 'running',
    }
  }
}
