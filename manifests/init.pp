# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# This class is the entry point for the duo_unix class. It will install and
# configure duo for various Linux distros.
#
# @summary This class installs and configures duo for various Linux distros
#
# @example
#   include duo_unix
#
# @param usage
#   Whether it is expected that duo will be enforced through ssh or pam
#
# @param ikey
#   The Integration Key for Duo
#
# @param skey
#   The Secret Key for Duo
#
# @param host
#   The API hostname (i.e. api-XXXXXXXX.duosecurity.com
#
class duo_unix (
  Enum['login', 'pam'] $usage                 = undef,
  String $ikey                                = undef,
  String $skey                                = undef,
  StdLib::Host $host                          = undef,
  Enum['latest', 'present', 'absent'] $ensure = $duo_unix::params::ensure,
  Enum['no', 'yes'] $fallback_local_ip        = $duo_unix::params::fallback_local_ip,
  Enum['fail', 'safe'] $failmode              = $duo_unix::params::failmode,
  Enum['no', 'yes'] $pushinfo                 = $duo_unix::params::pushinfo,
  Enum['no', 'yes'] $autopush                 = $duo_unix::params::autopush,
  Enum['no', 'yes'] $motd                     = $duo_unix::params::motd,
  Integer[1, 3] $prompts                      = $duo_unix::params::prompts,
  Enum['no', 'yes'] $accept_env_factor        = $duo_unix::params::accept_env_factor,
) inherits duo_unix::params
{
  include duo_unix::repo

  #
  # I need to figure out a neater way to do this, my assumptions about
  # being able to use a param for the resource name were wrong
  #
  case $facts['os']['family'] {
    'Debian': {
      package { $duo_unix::duo_package:
        ensure  => $ensure,
        require => Apt::Source['duo_unix'],
      }
    }
    'RedHat': {
      package { $duo_unix::duo_package:
        ensure  => $ensure,
        require => Yumrepo['duo_unix'],
      }
    }
  }
  
  if ($duo_unix::usage == 'login') {
    $owner = 'sshd'
  } else {
    $owner = 'root'
  }

  file { "/etc/duo/${duo_unix::usage}_duo.conf":
    ensure => $ensure,
    owner  => $owner,
    group  => 'root',
    mode   => '0600',
    content => template('duo_unix/duo.conf.erb'),
    require => Package[$duo_unix::duo_package]
  }
}
