# A description of what this class does
#
# @summary A short summary of the purpose of this class
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
