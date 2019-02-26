require 'spec_helper'

describe 'duo_unix::repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      
      it { is_expected.to compile.with_all_deps }

      if os =~ /ubuntu.*/

        if os != 'ubuntu-18.04-x86_64'
          it { should contain_apt__source('duo_unix')
            .with_location('https://pkg.duosecurity.com/Ubuntu')
            .with_architecture('i386,x86_64')
          }
        end

        if os == 'ubuntu-18.04-x86_64'
          it { should contain_apt__source('duo_unix')
            .with_location('https://pkg.duosecurity.com/Ubuntu')
            .with_release('bionic')
            .with_repos('main')
            .with_architecture('x86_64')
          }
        end
        
      end

      if os =~ /debian.*/
        it { should contain_apt__source('duo_unix').with_location('https://pkg.duosecurity.com/Debian') }
      end

      if os =~ /redhat.*/
        it { should contain_yumrepo('duo_unix').with_baseurl('https://pkg.duosecurity.com/RedHat/$releasever/$basearch') }
      end

      if os =~ /centos.*/
        it { should contain_yumrepo('duo_unix').with_baseurl('https://pkg.duosecurity.com/CentOS/$releasever/$basearch') }
      end

    end
  end
end
