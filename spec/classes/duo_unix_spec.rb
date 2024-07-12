require 'spec_helper'

describe 'duo_unix' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:params) do
        {
          'usage'             => 'login',
          'ikey'              => 'testikey',
          'skey'              => 'testskey',
          'host'              => 'api-XXXXXXXX.duosecurity.com',
        }
      end
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      if os.match? %r{(?:debian|ubuntu).*}
        it { is_expected.to contain_package('duo-unix').that_requires('Apt::Source[duosecurity]') }
        it { is_expected.to contain_apt__source('duosecurity') }
      end

      if os.match? %r{(?:centos|redhat).*}
        it { is_expected.to contain_package('duo_unix').that_requires('Yumrepo[duosecurity]') }
        it { is_expected.to contain_yumrepo('duosecurity') }
      end

      it {
        is_expected.to contain_file('/etc/duo/login_duo.conf')
          .with_ensure('file')
          .with_owner('sshd')
          .without_content(%r{^cafile.+})
      }
    end

    context 'with cafile defined' do
      let(:params) do
        {
          'usage'  => 'login',
          'ikey'   => 'testikey',
          'skey'   => 'testskey',
          'host'   => 'api-XXXXXXXX.duosecurity.com',
          'cafile' => '/dne',
        }
      end
      let(:facts) { os_facts }

      it {
        is_expected.to contain_file('/etc/duo/login_duo.conf')
          .with_content(%r{^cafile=/dne})
      }
    end

    context 'with usage pam and ensure latest' do
      let(:params) do
        {
          'usage'          => 'pam',
          'ikey'           => 'testikey',
          'skey'           => 'testskey',
          'host'           => 'api-XXXXXXXX.duosecurity.com',
          'package_ensure' => 'latest',
        }
      end
      let(:facts) { os_facts }

      let :pre_condition do
        "yumrepo { 'epel':
          ensure => present
        }"
      end

      it {
        is_expected.to contain_file('/etc/duo/pam_duo.conf')
          .with_ensure('file')
          .with_owner('root')
      }

      if os.match? %r{(?:centos|redhat).*}
        it {
          is_expected.to contain_package('duo_unix')
            .with_ensure('latest')
        }
      end

      if os.match? %r{(?:debian|ubuntu).*}
        it {
          is_expected.to contain_package('duo-unix')
            .with_ensure('latest')
        }
      end
    end

    context 'with unmanaged repos' do
      let(:params) do
        {
          'usage'       => 'login',
          'ikey'        => 'testikey',
          'skey'        => 'testskey',
          'host'        => 'api-XXXXXXXX.duosecurity.com',
          'manage_repo' => false,
        }
      end
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.not_to contain_apt__source('duosecurity') }
      it { is_expected.not_to contain_yumrepo('duosecurity') }
    end
  end
end
