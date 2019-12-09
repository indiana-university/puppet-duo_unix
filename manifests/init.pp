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
# @param manage_pam
#   Whether to alter the pam config to require Duo
#   The default is true
#
# @param manage_ssh
#   Whether to alter the ssh config to require Duo
#   The default is true
#
# @param manage_repo
#   Whether to manage the duo repo
#   The default is true
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
# @param ensure
#   This controls the package and config states
#   The default is "present"
#
# @param fallback_local_ip
#   If Duo Unix cannot detect the IP address of the client, setting 
#   fallback_local_ip = yes will cause Duo Unix to send the IP address 
#   of the server it is running on.
#   The default is "no"
#
# @param failmode
#   On service or configuration errors that prevent Duo authentication, 
#   fail "safe" (allow access) or "secure" (deny access). 
#   The default is "safe".
#
# @param pushinfo
#   Include information such as the command to be executed in the Duo 
#   Push message. Either "yes" or "no". 
#   The default is "no".
#
# @param autopush
#   Either "yes" or "no". Default is "no". If "yes", Duo Unix will 
#   automatically send a push login request to the user's phone, falling back
#   on a phone call if push is unavailable. Note that this effectively disables
#   passcode authentication. If "no", the user will be prompted to choose an 
#   authentication method.
#   When configured with autopush = yes, we recommend setting prompts = 1
#   The default is "no"
#
# @param motd
#   Print the contents of /etc/motd to screen after a successful login. Either
#   "yes" or "no". 
#   The default is "no"
#
# @param prompts
#   If a user fails to authenticate with a second factor, Duo Unix will prompt
#   the user to authenticate again. This option sets the maximum number of 
#   prompts that Duo Unix will display before denying access. 
#   Must be 1, 2, or 3. 
#   Default is 3.
#
# @param accept_env_factor
#   Look for factor selection or passcode in the $DUO_PASSCODE environment 
#   variable before prompting the user for input. When $DUO_PASSCODE is 
#   non-empty, it will override autopush.
#   Default is "no"
#
class duo_unix (
  Enum['login', 'pam'] $usage,
  String $ikey,
  String $skey,
  StdLib::Host $host,
  Boolean $manage_pam                         = $duo_unix::params::manage_pam,
  Boolean $manage_ssh                         = $duo_unix::params::manage_ssh,
  Boolean $manage_repo                        = $duo_unix::params::manage_repo,
  Enum['latest', 'present', 'absent'] $ensure = $duo_unix::params::ensure,
  Enum['no', 'yes'] $fallback_local_ip        = $duo_unix::params::fallback_local_ip,
  Enum['fail', 'safe'] $failmode              = $duo_unix::params::failmode,
  Enum['no', 'yes'] $pushinfo                 = $duo_unix::params::pushinfo,
  Enum['no', 'yes'] $autopush                 = $duo_unix::params::autopush,
  Enum['no', 'yes'] $motd                     = $duo_unix::params::motd,
  Integer[1, 3] $prompts                      = $duo_unix::params::prompts,
  Enum['no', 'yes'] $accept_env_factor        = $duo_unix::params::accept_env_factor,
  Optional[StdLib::Httpurl] $proxy            = undef,
  Optional[String] $groups                    = undef,
  Boolean $show_diff                          = true,
) inherits duo_unix::params
{
  if $manage_repo {
    include duo_unix::repo
  }

  #
  # I need to figure out a neater way to do this, my assumptions about
  # being able to use a param for the resource name were wrong
  #
  package { $duo_unix::duo_package:
    ensure => $ensure
  }

  if ($duo_unix::usage == 'login') {
    $owner = 'sshd'
    if ($manage_ssh) {
      include duo_unix::ssh_config
    }
  } else {
    $owner = 'root'
    if ($manage_pam) {

      if ($manage_pam and $usage == 'login') {
        include duo_unix::pam_ssh_config
      }

      include duo_unix::pam_config
    }
  }

  file { "/etc/duo/${duo_unix::usage}_duo.conf":
    ensure    => $ensure,
    owner     => $owner,
    group     => 'root',
    mode      => '0600',
    show_diff => $show_diff,
    content   => template('duo_unix/duo.conf.erb'),
    require   => Package[$duo_unix::duo_package]
  }
}
