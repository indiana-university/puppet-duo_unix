# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include duo_unix::pam_config
class duo_unix::pam_config inherits duo_unix::params
{
  $aug_pam_path = "/files${duo_unix::params::pam_file}"
  $aug_match    = "${aug_pam_path}/*/module[. = '${duo_unix::params::pam_module}']"


  case $facts['os']['family'] {
    'Debian': {
      augeas { 'Duo Security PAM Configuration':
        context => $duo_unix::params::pam_file,
        changes => [
          "set ${aug_pam_path}/1/control ${duo_unix::params::pam_unix_control}",
          "ins 100 after ${aug_pam_path}/1",
          "set ${aug_pam_path}/100/type auth",
          "set ${aug_pam_path}/100/control '[success=1 default=ignore]'",
          "set ${aug_pam_path}/100/module ${duo_unix::params::pam_module}"
        ],
        require => Package[$duo_unix::params::duo_package],
        onlyif  => "match ${aug_match} size == 0";
      }
    }
    'RedHat': {
      augeas { 'Duo Security PAM Configuration':
        changes => [
          "set ${aug_pam_path}/2/control ${duo_unix::params::pam_unix_control}",
          "ins 100 after ${aug_pam_path}/2",
          "set ${aug_pam_path}/100/type auth",
          "set ${aug_pam_path}/100/control sufficient",
          "set ${aug_pam_path}/100/module ${duo_unix::params::pam_module}"
        ],
        require => Package[$duo_unix::params::duo_package],
        onlyif  => "match ${aug_match} size == 0";
      }
    }
    default: {
      fail("Module ${module_name} does not support ${facts['os']['release']['full']}")
    }
  }
}
