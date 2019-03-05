# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include duo_unix::pam_ssh_config
class duo_unix::pam_ssh_config inherits duo_unix::params
{
  augeas { 'Duo Security SSH Configuration':
    context => '/files/etc/ssh/sshd_config',
    changes => [
      'set UsePAM yes',
      'set UseDNS no',
      'set ChallengeResponseAuthentication yes',
    ],
    require => Package[$duo_unix::params::duo_package],
    notify  => Service[$duo_unix::params::ssh_service],
  }

  if !defined(Service[$duo_unix::params::ssh_service]) {
    service { $duo_unix::params::ssh_service:
      ensure => 'running',
    }
  }
}
