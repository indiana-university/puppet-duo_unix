# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# This class will add a repository to use to install the duo_unix package
# from Duo Inc.
#
# @summary Add an apt/yum repo for Debian/RedHat based systems
#
# @example
#   include duo_unix::repo
#
class duo_unix::repo inherits duo_unix::params {
  $pkg_base_url = 'https://pkg.duosecurity.com'

  case $facts['os']['family'] {
    'Debian': {
      # As of 18.04 there is no i386 release of duo_unix
      if ($facts['os']['release']['full'] >= '18.04') {
        $architecture = 'amd64'
      } else {
        $architecture = 'i386,amd64'
      }

      apt::source { 'duosecurity':
        ensure       => 'present',
        comment      => 'Duo Inc. official repository',
        location     => "${pkg_base_url}/${facts['os']['name']}",
        release      => $::lsbdistcodename,
        repos        => 'main',
        architecture => $architecture,
        key          => {
          id     => 'DF1A60B56EFE2DC8CA8A9A6101EF98E910448FDB',
          source => 'https://duo.com/DUO-GPG-PUBLIC-KEY.asc',
        },
      }

      Apt::Source['duosecurity'] -> Package<| title == $duo_unix::params::duo_package |>
    }
    'RedHat': {
      yumrepo { 'duosecurity':
        ensure   => 'present',
        enabled  => '1',
        descr    => 'Duo Inc. officical repository',
        baseurl  => "${pkg_base_url}/${facts['os']['name']}/\$releasever/\$basearch",
        gpgkey   => 'https://duo.com/DUO-GPG-PUBLIC-KEY.asc',
        gpgcheck => '1',
      }

      Yumrepo['duosecurity'] -> Package<| title == $duo_unix::params::duo_package |>
    }
    default: {
      fail("Module ${module_name} does not support ${facts['os']['release']['full']}")
    }
  }
}
