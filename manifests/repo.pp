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

      #
      # Because the docker images for ubuntu do not have the lsb-release
      # package installed by default we cannot rely on facter for info
      # provided by that binary here. We have to map our own codenames.
      #
      $codename_mapping = {
        '12.04' => 'quantal',
        '14.04' => 'trusty',
        '16.04' => 'xenial',
        '18.04' => 'bionic',
        '20.04' => 'focal',
        '6' => 'squeeze',
        '7' => 'wheezy',
        '8' => 'jessie',
        '9' => 'stretch',
        '10' => 'buster',
      }

      ensure_resource(
        'package',
        'apt-transport-https',
        {'ensure' => 'present'}
      )

      ensure_resource(
        'package',
        'lsb-release',
        {'ensure' => 'present'}
      )

      apt::source { 'duosecurity':
        ensure       => 'present',
        comment      => 'Duo Inc. official repository',
        location     => "${pkg_base_url}/${facts['os']['name']}",
        release      => $codename_mapping[$facts['os']['release']['full']],
        repos        => 'main',
        architecture => $architecture,
        key          => {
          id     => 'D8EC4E2058401AE5578C4B3F4B44CE3DFF696172',
          source => 'https://duo.com/DUO-GPG-PUBLIC-KEY.asc',
        },
        require      => [
          Package['apt-transport-https'],
          Package['lsb-release'],
        ],
      }

      Apt::Source['duosecurity'] -> Package<| title == $duo_unix::params::duo_package |>
    }
    'RedHat': {
      $osname = $facts['os']['name'] ? {
        'CentOS'    => 'CentOS',
        default     => 'RedHat',
      }

      yumrepo { 'duosecurity':
        ensure   => 'present',
        enabled  => '1',
        descr    => 'Duo Inc. officical repository',
        baseurl  => "${pkg_base_url}/${osname}/\$releasever/\$basearch",
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
