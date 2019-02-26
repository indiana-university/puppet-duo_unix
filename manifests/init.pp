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
  Enum['login', 'pam'] $usage,
  String $ikey,
  String $skey,
  StdLib::Host $host,
  Enum['latest', 'present', 'absent'] $ensure = 'present',
) inherits duo_unix::params
{
  include duo_unix::repo

  package { $duo_unix::duo_package:
    ensure => $ensure
  }
}
