# Copyright © 2020 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# Manage SSH set to false here tells the module not to manage the SSH config
# file. This is useful if you manage it elsewhere.
#
# Usage set to login here tells the module to set up the configuration to use
# duo as a force_command in the SSH configuration. You could also set it to PAM
# which should set up your pam stack to use Duo.
#
# The ikey, skey, and host are the values you were given by Duo Inc.
# 
# Motd set to yes here will cause the contents of /etc/motd to be displayed
# after login
# 
class { 'duo_unix':
  manage_ssh => false,
  usage      => 'login',
  ikey       => 'example_i_key',
  skey       => 'example_s_key',
  host       => 'example.net',
  motd       => 'yes',
}
