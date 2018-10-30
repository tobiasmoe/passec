# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include passec::install
class passec::install {
  if $::osfamily == 'windows' {

    /*
    include chocolatey

    package { 'git':
      ensure   => present,
      provider => chocolatey,
    }

    windows_env { 'PATH=C:\Program Files\Git\cmd':
      ensure  => present,
      require => Package['git'],
    }

    exec { 'Refresh-env':
      command     => '$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")',
      provider    => powershell,
      subscribe   => Windows_env['PATH=C:\Program Files\Git\cmd'],
      refreshonly => true,
      require     => Windows_env['PATH=C:\Program Files\Git\cmd'],
    }

    vcsrepo { $passec::install_directory:
      ensure   => present,
      provider => git,
      source   => 'https://github.com/JacksonVD/PwnedPasswordsDLL-API',
      require  => Exec['Refresh-env'],
    }
  }
  */


  #TEMPORARY FIX FOR ISSUE https://github.com/voxpupuli/puppet-download_file/issues/82
    exec { 'TLS-Fix':
      command  => '[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11"',
      provider => powershell,
      onlyif   => '! Test-Path -Path C:\Windows\system32\PwnedPasswordsDLL-API.dll -PathType Leaf',
    }

    download_file { 'Download PwnedPassordDLL':
      url                   => 'https://github.com/JacksonVD/PwnedPasswordsDLL-API/releases/download/v1.0/PwnedPasswordsDLL-API.dll',
      destination_directory => 'C:\Windows\system32',
      require               => Exec['TLS-Fix'],
    }
  }
}
