require 'spec_helper'

describe 'passec::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:node_params) do
        {
          'passec::registry_values' => ['PwnedPasswordsDLL-API','rassfm','scecli']
           'passec::domain_name'    => 'borg.trek'
        }

      it { is_expected.to compile }
      it { is_expected.to contain_registry_value('HKLM').with(
        'ensure' => 'present',
        'path'   => 'HKLM\System\CurrentControlSet\Control\LSA\Notification Packages',
        'type'   => 'array',
        'data'   => '$passec::registry_values',
      )
    end
  end
end
