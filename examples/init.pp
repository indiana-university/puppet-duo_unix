# Copyright © 2020 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Claus
#
class { 'duo_unix':
  manage_ssh => false,
  usage      => 'login',
  ikey       => 'example_i_key',
  skey       => 'example_s_key',
  host       => 'example.net',
  motd       => 'yes',
}
