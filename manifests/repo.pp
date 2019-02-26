# This class will add a repository to use to install the duo_unix package
# from Duo Inc.
#
# @summary Add an apt/yum repo for Debian/RedHat based systems
#
# @example
#   include duo_unix::repo
#
class duo_unix::repo {
  $pkg_base_url = 'https://pkg.duosecurity.com'

  case $facts['os']['family'] {
    'Debian': {
      # As of 18.04 there is no i386 release of duo_unix
      if ($facts['os']['release']['full'] >= '18.04') {
        $architecture = 'x86_64'
      } else {
        $architecture = 'i386,x86_64'
      }

      apt::source { 'duo_unix':
        ensure       => 'present',
        comment      => 'Duo Inc. official repository',
        location     => "${pkg_base_url}/${facts['os']['name']}",
        release      => $::lsbdistcodename,
        repos        => 'main',
        architecture => $architecture,
        key          => {
          id     => '30BFE0242B19592EB122211D1CC91FC615D32EFC',
          source => 'https://duo.com/APT-GPG-KEY-DUO',
        },
      }
    }
    'RedHat': {
      yumrepo { 'duo_unix':
        ensure   => 'present',
        enabled  => true,
        descr    => 'Duo Inc. officical repository',
        baseurl  => "${pkg_base_url}/${facts['os']['name']}/\$releasever/\$basearch",
        gpgcheck => true,
        gpgkey   => 'https://duo.com/RPM-GPG-KEY-DUO',
      }
    }
    default: {
      fail("Module ${module_name} does not support ${facts['os']['release']['full']}")
    }
  }
}
