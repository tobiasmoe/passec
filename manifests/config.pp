# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include passec::config
class passec::config {
  if $::osfamily == 'windows' {
    if $passec::api {
      registry_value { 'HKLM':
        ensure => present,
        path   => 'HKLM\System\CurrentControlSet\Control\LSA\Notification Packages',
        type   => array,
        data   => $passec::registry_values_api,
      }
    }
    else {
      registry_value { 'HKLM':
        ensure => present,
        path   => 'HKLM\System\CurrentControlSet\Control\LSA\Notification Packages',
        type   => array,
        data   => $passec::registry_values,
      }
    }
    exec { 'GPO':
      command     => "Set-ADDefaultDomainPasswordPolicy -Identity ${passec::domain_name} -ComplexityEnabled \$true",
      provider    => powershell,
      subscribe   => Registry_value['HKLM'],
      refreshonly => true,
    }
    if $passec::restartadds {
      exec { 'Restart-ADDS':
        command     => 'Restart-Service -Name NTDS -Force',
        provider    => powershell,
        subscribe   => Exec['GPO'],
        refreshonly => true,
      }
    }
    if $passec::reboot {
      reboot { 'last':
        subscribe => Exec['Restart-ADDS'],
      }
    }
  }
  else {
    notify {"Your operating system ${::osfamily} is not supported":}
  }
}
