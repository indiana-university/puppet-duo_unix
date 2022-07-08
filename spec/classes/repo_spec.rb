require 'spec_helper'

describe 'duo_unix::repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      if os.match? %r{ubuntu.*}

        if os != 'ubuntu-18.04-x86_64'
          it {
            is_expected.to contain_apt__source('duosecurity')
              .with_location('https://pkg.duosecurity.com/Ubuntu')
              .with_architecture('i386,amd64')
          }
        end

        if os == 'ubuntu-18.04-x86_64'
          it {
            is_expected.to contain_apt__source('duosecurity')
              .with_location('https://pkg.duosecurity.com/Ubuntu')
              .with_release('bionic')
              .with_repos('main')
              .with_architecture('amd64')
          }
        end

        if os == 'ubuntu-20.04-x86_64'
          it {
            is_expected.to contain_apt__source('duosecurity')
              .with_location('https://pkg.duosecurity.com/Ubuntu')
              .with_release('focal')
              .with_repos('main')
              .with_architecture('amd64')
          }
        end

      end

      if os.match? %r{debian.*}
        it { is_expected.to contain_apt__source('duosecurity').with_location('https://pkg.duosecurity.com/Debian') }
      end

      if os.match? %r{centos.*}
        it { is_expected.to contain_yumrepo('duosecurity').with_baseurl('https://pkg.duosecurity.com/CentOS/$releasever/$basearch') }
      end

      if os.match? %r{(redhat.*|rocky.*|alma.*)}
        it { is_expected.to contain_yumrepo('duosecurity').with_baseurl('https://pkg.duosecurity.com/RedHat/$releasever/$basearch') }
      end
    end
  end
end
