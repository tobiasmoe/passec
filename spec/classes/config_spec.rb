require 'spec_helper'

describe 'passec::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:node_params) do
        {
          'passec::registry_values_api' => ['PwnedPasswordsDLL-API', 'rassfm', 'scecli'],
          'passec::registry_values' 	=> ['PwnedPasswordsDLL', 'rassfm', 'scecli'],
          'passec::domain_name'     	=> 'borg.trek',
          'passec::reboot'          	=> 'true',
          'passec::restartadds'     	=> 'true',
          'passec::api'		    	=> 'false',
        }
      end

      it { is_expected.to compile }
      it {
        is_expected.to contain_registry_value('HKLM').with(
          'ensure' => 'present',
          'path'   => 'HKLM\System\CurrentControlSet\Control\LSA\Notification Packages',
          'type'   => 'array',
        )
      }
      it { is_expected.to contain_exec('GPO').that_subscribes_to('Registry_value[HKLM]') }
      it {
        is_expected.to contain_exec('Restart-ADDS').with(
          'command'     => 'Restart-Service -Name NTDS -Force',
          'provider'    => 'powershell',
        )
      }
      it { is_expected.to contain_exec('Restart-ADDS').that_subscribes_to('Exec[GPO]') }
      it { is_expected.to contain_reboot('last').that_subscribes_to('Exec[Restart-ADDS]') }
    end
  end
end
