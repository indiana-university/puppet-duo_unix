require 'spec_helper'

describe 'duo_unix::pam_config' do
  let :pre_condition do
    "package { 'duo_unix':
      ensure => 'installed'
    }
    package { 'duo-unix':
      ensure => 'installed'
    }
    service { 'sshd':
      ensure => 'running'
    }"
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_augeas('Duo Security PAM Configuration') }
    end
  end
end
