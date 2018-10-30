require 'spec_helper'

describe 'passec::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_download_file('Download PwnedPassordDLL').with(
        'url'                   => 'https://github.com/JacksonVD/PwnedPasswordsDLL-API/releases/download/v1.0/PwnedPasswordsDLL-API.dll',
        'destination_directory' => 'C:\Windows\system32'
        )
      it { is_expected.to contain_download_file('Download PwnedPassordDLL').that_requires('Exec[TLS-Fix]') }

    end
  end
end
