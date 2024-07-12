require 'spec_helper'

describe 'duo_unix::pam_ssh_config' do
  let :pre_condition do
    "package { 'duo_unix':
      ensure => 'installed'
    }
    package { 'duo-unix':
      ensure => 'installed'
    }
    package { 'pam_ssh_user_auth':
      ensure => 'installed'
    }"
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      case os_facts[:osfamily]
      when 'RedHat'
        keyonly = true
        context 'keyonly', if: keyonly do
          let(:params) { { 'keyonly' => true } }

          it {
            is_expected.to contain_augeas('Duo Security SSH Configuration')
              .with_context('/files/etc/ssh/sshd_config')
              .with_changes(
                [
                  'set UsePAM yes',
                  'set UseDNS no',
                  'set ChallengeResponseAuthentication yes',
                  'set ExposeAuthInfo yes',
                  'set AuthenticationMethods "publickey,keyboard-interactive:pam"',
                ],
              )
          }
        end

        keyonly = false
        context 'not-keyonly', if: !keyonly do
          let(:params) { { 'keyonly' => false } }

          it {
            is_expected.to contain_augeas('Duo Security SSH Configuration')
              .with_context('/files/etc/ssh/sshd_config')
              .with_changes(
                [
                  'set UsePAM yes',
                  'set UseDNS no',
                  'set ChallengeResponseAuthentication yes',
                  'set ExposeAuthInfo yes',
                  'set AuthenticationMethods "gssapi-with-mic,keyboard-interactive:pam publickey,keyboard-interactive:pam keyboard-interactive:pam,keyboard-interactive:pam"',
                ],
              )
          }
        end
      else
        it {
          is_expected.to contain_augeas('Duo Security SSH Configuration')
            .with_context('/files/etc/ssh/sshd_config')
            .with_changes(['set UsePAM yes', 'set UseDNS no', 'set ChallengeResponseAuthentication yes'])
        }
      end
    end
  end
end
