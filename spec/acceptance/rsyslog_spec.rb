require 'spec_helper_acceptance'

rsyslog_config_file = '/etc/rsyslog.d/60-duo_unix.conf'

# manage_ssh is needed for testing because sshd is already used for
# the testing environment and gives false failures without setting to false here
pp_static_content = <<-PUPPETCODE
    class { 'duo_unix':
        usage       => 'login',
        ikey        => 'ikey',
        skey        => 'skey',
        host        => 'host',
        manage_ssh  => false,
        duo_rsyslog => true,
    }
PUPPETCODE

def test_rsyslog(pp, filename)
  idempotent_apply(pp)
  expect(file(filename)).to be_file
end

describe 'rsyslog configuration' do
  context 'applying rsyslog configuration'
  it do
    test_rsyslog(pp_static_content, rsyslog_config_file)
  end
end
