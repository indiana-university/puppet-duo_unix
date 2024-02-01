# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# This class just holds some parameter values for use elsewhere
#
# @summary Default parameter values for the duo_unix module
#
class duo_unix::params {
  $package_ensure     = 'present'
  $config_ensure      = 'file'
  $manage_pam         = true
  $manage_ssh         = true
  $manage_repo        = true
  $fallback_local_ip  = 'no'
  $failmode           = 'safe'
  $pushinfo           = 'no'
  $autopush           = 'no'
  $motd               = 'no'
  $prompts            = 3
  $accept_env_factor  = 'no'
  $pam_unix_control   = 'requisite'

  $pam_module = $facts['os']['architecture'] ? {
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
      $pam_ssh_user_auth_package = 'pam_ssh_user_auth'
      $ssh_service = 'sshd'
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
