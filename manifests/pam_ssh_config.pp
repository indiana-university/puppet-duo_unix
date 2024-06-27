# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# @summary This class sets sshd up to use PAM
#
# @param keyonly
#   Configure pam to accept SSH keys only as primary factor
#   The default is false.
#
# This class will set the following parameters in the sshd_config file
#   * UsePAM                          yes
#   * UseDNS                          no
#   * ChallengeResponseAuthentication yes
#   * ExposeAuthInfo                  yes (on RedHat family only)
#   * AuthenticationMethods based on keyonly (on RedHat family only)
#
# @example
#   include duo_unix::pam_ssh_config
class duo_unix::pam_ssh_config (
  Boolean       $keyonly = false
) inherits duo_unix::params {
  if ($facts['os']['family'] == 'RedHat') {
    augeas { 'Duo Security SSH Configuration':
      context => '/files/etc/ssh/sshd_config',
      changes => [
        'set UsePAM yes',
        'set UseDNS no',
        'set ChallengeResponseAuthentication yes',
        'set ExposeAuthInfo yes',
        $keyonly ? {
          true  => 'set AuthenticationMethods "publickey,keyboard-interactive:pam"',
          false => 'set AuthenticationMethods "gssapi-with-mic,keyboard-interactive:pam publickey,keyboard-interactive:pam keyboard-interactive:pam,keyboard-interactive:pam"'
        },
      ],
      require => [
        Package[$duo_unix::params::duo_package],
        Package[$duo_unix::params::pam_ssh_user_auth_package]
      ],
      notify  => Service[$duo_unix::params::ssh_service],
    }
  }
  else {
    augeas { 'Duo Security SSH Configuration':
      context => '/files/etc/ssh/sshd_config',
      changes => [
        'set UsePAM yes',
        'set UseDNS no',
        'set ChallengeResponseAuthentication yes',
      ],
      require => [Package[$duo_unix::params::duo_package]],
      notify  => Service[$duo_unix::params::ssh_service],
    }
  }

  if !defined(Service[$duo_unix::params::ssh_service]) {
    service { $duo_unix::params::ssh_service:
      ensure => 'running',
    }
  }
}
