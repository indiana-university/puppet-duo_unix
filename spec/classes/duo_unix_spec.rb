require 'spec_helper'

describe 'duo_unix' do
  let(:params) do
    {
      'usage' => 'login',
      'ikey'  => 'test',
      'skey'  => 'test1234',
      'host'  => 'test.net'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:usage) { 'login' }
      let(:ikey) { 'test' }
      let(:skey) { 'test1234' }
      let(:host) { 'test.net' }

      it { is_expected.to compile.with_all_deps }
      it { expect(usage).to eq('login') }
      it { expect(ikey).to eq('test') }
      it { expect(skey).to eq('test1234') }
      it { expect(host).to eq('test.net') }

      if os =~ /(?:debian|ubuntu).*/
        it { should contain_package('duo-unix') }
      end

      if os =~ /(?:centos|redhat).*/
        it { should contain_package('duo_unix') }
      end

    end
  end
end
