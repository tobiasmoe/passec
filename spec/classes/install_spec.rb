require 'spec_helper'

describe 'passec::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'something' }
      let(:node_params) { { 'passec::api' => 'true' } }

      it { is_expected.to compile }
      it {
        is_expected.to contain_exec('TLS-Fix-API').with(
          'command'  => '[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11"',
          'provider' => 'powershell',
          'onlyif'   => '! Test-Path -Path C:\Windows\system32\PwnedPasswordsDLL-API.dll -PathType Leaf',
        )
      }
      it {
        is_expected.to contain_download_file('Download PwnedPasswordDLL-API').with(
          'url'                   => 'https://github.com/JacksonVD/PwnedPasswordsDLL-API/releases/download/v1.0/PwnedPasswordsDLL-API.dll',
          'destination_directory' => 'C:\Windows\system32',
        )
      }
      it { is_expected.to contain_download_file('Download PwnedPasswordDLL-API').that_requires('Exec[TLS-Fix-API]') }
    end
  end
end
