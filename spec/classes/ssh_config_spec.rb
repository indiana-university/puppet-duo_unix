require 'spec_helper'
describe 'duo_unix::ssh_config' do
  let(:pre_condition) { "package { 'duo_unix': ensure => 'installed' } package { 'duo-unix': ensure => 'installed' }"}

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
