# This class creates a configuration file
# (/etc/rsyslog.d/60-duo_unix.conf) to direct
# login_duo messages into the system's auth log
#
# @summary This class configures rsyslog.d to send Duo-related auth logs 
#   into the system's auth log in addition to its default syslog logging destination. 
#   This is to facilitate the use of fail2ban with Duo conditions by
#   confining all auth-related activity to the auth log.
#
# @example
#   include duo_unix::rsyslog
class duo_unix::rsyslog inherits duo_unix::params {
  package { 'rsyslog': }
  file { '/etc/rsyslog.d/60-duo_unix.conf':
    content => "# This file is managed by Puppet. DO NOT EDIT.\nlogin_duo\t\t${duo_unix::params::auth_logfile}",
  }
}
