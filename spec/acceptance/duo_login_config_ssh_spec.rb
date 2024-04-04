require 'spec_helper_acceptance'

describe 'Duo login + ssh configuration' do
  context 'applying duo login configuration + ssh'

  let(:duo_config_file) { '/etc/duo/login_duo.conf' }

  let(:pp) { 
"class { 'duo_unix': 
  manage_ssh => true,
  usage      => 'login',
  ikey       => 'ikey',
  skey       => 'skey',
  host       => 'host',
  motd       => 'yes',
}
"
  }

  let(:duo_conf_expected_contents) {
";
; This file is managed by Puppet.
; Any changes made will automatically be overwritten
;

[duo]
; Duo integration key
ikey=ikey

; Duo secret key
skey=skey

; Duo API host
host=host

; Fallback local IP
fallback_local_ip=no

; Failure mode
failmode=safe

; Push info
pushinfo=no

; Auto push
autopush=no

; Prompts
prompts=3

; Accept environment factor
accept_env_factor=no

; MOTD display
motd=yes
"
  }

  if 'apply idempotently' do
    idempotent_apply(pp)
  end
  
  describe file('/etc/duo/login_duo.conf') do 
    it { is_expected.to be_file }
    its(:content) { should match duo_conf_expected_contents }
  end

  describe file('etc/ssh/sshd_config') do
    it { is_expected.to be_file }
    it { should contain 'ForceCommand /usr/sbin/login_duo'}
    it { should contain 'PermitTunnel no' }
  end
end