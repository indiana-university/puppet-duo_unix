# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# This class just holds some parameter values for use elsewhere
#
# @summary Default parameter values for the duo_unix module
#
class duo_unix::params {

  $pam_module = $::architecture ? {
    'i386'   => '/lib/security/pam_duo.so',
    'i686'   => '/lib/security/pam_duo.so',
    default  => '/lib64/security/pam_duo.so',
  }

  case $facts['os']['family'] {
    'Debian': {
      $duo_package = 'duo-unix'
      $ssh_service = 'sshd'
      $pam_file    = '/etc/pam.d/common-auth'
    }
    'RedHat': {
      $duo_package = 'duo_unix'
      $ssh_service = 'ssh'
      $pam_file = $facts['os']['release']['major'] ? {
        '5' => '/etc/pam.d/system-auth',
        default => '/etc/pam.d/password-auth',
      }
    }
    default: {
      fail("Module ${module_name} does not support ${facts['os']['release']['full']}")
    }
  }
}
