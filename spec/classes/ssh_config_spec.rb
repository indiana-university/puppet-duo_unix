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
        accept_env_factor => 'yes' }"
    end

    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end

    context 'with accept_env_factor => yes' do
      let(:facts) { os_facts }

      it {
        is_expected.to contain_file('/etc/duo/login_duo.conf')
          .with_content(%r{^accept_env_factor=yes$})
      }
      describe 'sshd' do
        # Look for augeas['duo_ssh_env'] because sshd_config is a pre-existing and therefore not testable in the catalog by Rspec
        # Testing for specific augeas changes is also not possible: See https://github.com/indiana-university/puppet-duo_unix/issues/45
        it 'Finds duo_ssh_env augeas resource' do
          is_expected.to contain_augeas('duo_ssh_env')
        end
      end
    end
  end
end
