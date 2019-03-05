require 'spec_helper'

describe 'duo_unix::pam_ssh_config' do
  let(:pre_condition) { "package { 'duo_unix': ensure => 'installed' } package { 'duo-unix': ensure => 'installed' }"}

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_augeas('Duo Security SSH Configuration')
        .with_context('/files/etc/ssh/sshd_config')
        .with_changes(['set UsePAM yes', 'set UseDNS no', 'set ChallengeResponseAuthentication yes'])
      }
    end
  end
end
