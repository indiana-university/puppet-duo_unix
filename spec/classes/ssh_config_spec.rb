require 'spec_helper'
describe 'duo_unix::ssh_config' do
  let(:pre_condition) { "package { 'duo_unix': ensure => 'installed' } package { 'duo-unix': ensure => 'installed' }" }

  on_supported_os.each do |os, os_facts|
    let :pre_condition do
      "class { 'duo_unix':
        usage => 'login',
        ikey => 'testikey',
        skey => 'testskey',
        host => 'api-XXXXXXXX.duosecurity.com',
        duo_rsyslog => true,
        accept_env_factor => 'yes' }"
    end

    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end

    context 'with duo_rsyslog => true' do
      let(:facts) { os_facts }

      it {
        is_expected.to contain_file('/etc/rsyslog.d/60-duo_unix.conf')
      }
    end

    context 'with accept_env_factor => yes' do
      let(:facts) { os_facts }

      it {
        is_expected.to contain_file('/etc/duo/login_duo.conf')
          .with_content(%r{^accept_env_factor=yes$})
      }
    end
  end
end
