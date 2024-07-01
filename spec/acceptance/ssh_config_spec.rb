require 'spec_helper_acceptance'

duo_config_file = '/etc/duo/login_duo.conf'

# manage_ssh is needed for testing because sshd is already used for
# the testing environment and gives false failures without setting to false here
pp_static_content = <<-PUPPETCODE
    class { 'duo_unix':
        manage_ssh => false,
        usage      => 'login',
        ikey       => 'ikey',
        skey       => 'skey',
        host       => 'host',
        motd       => 'yes',
    }
PUPPETCODE

expected_contents = <<-FILECONTENTS
;
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
FILECONTENTS

def test_duo(pp, expected_contain, filename)
  idempotent_apply(pp)
  expect(file(filename)).to be_file
  expect(file(filename)).to contain expected_contain
end

describe 'Duo configuration' do
  context 'applying duo configuration'
  it do
    test_duo(pp_static_content, expected_contents, duo_config_file)
  end
end
