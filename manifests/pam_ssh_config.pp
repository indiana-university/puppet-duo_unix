# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# @summary This class sets sshd up to use PAM
#
# This class will set the following parameters in the sshd_config file
#   * UsePAM                          yes
#   * UseDNS                          no
#   * ChallengeResponseAuthentication yes
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
