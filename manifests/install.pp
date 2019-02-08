# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include passec::install
class passec::install {
  if $::osfamily == 'windows' {
    if $passec::api {
    #TEMPORARY FIX FOR ISSUE https://github.com/voxpupuli/puppet-download_file/issues/82
      exec { 'TLS-Fix-API':
        command  => '[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11"',
        provider => powershell,
        creates  =>  'C:\windows\System32\PwnedPasswordsDLL-API.dll',
      }
      download_file { 'Download PwnedPasswordDLL-API':
        url                   => 'https://github.com/JacksonVD/PwnedPasswordsDLL-API/releases/download/2.1/PwnedPasswordsDLL-API.dll',
        destination_directory => 'C:\Windows\system32',
        require               => Exec['TLS-Fix-API'],
      }
    }
    else {
      exec { 'TLS-Fix':
        command  => '[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11"',
        provider => powershell,
        creates  => 'C:\windows\System32\PwnedPasswordsDLL.dll',
      }
      download_file { 'Download PwnedPasswordDLL':
        url                   => 'https://github.com/JacksonVD/PwnedPasswordsDLL/releases/download/3.1/PwnedPasswordsDLL.dll',
        destination_directory => 'C:\Windows\system32',
        require               => Exec['TLS-Fix'],
      }
      archive {'pwned-passwords-sha1-ordered-by-count-v4.txt':
        path         => 'C:\pwned-passwords-sha-ordered-by-count-v4.7z',
        extract      => true,
        extract_path => 'C:/',
        source       => 'https://downloads.pwnedpasswords.com/passwords/pwned-passwords-sha1-ordered-by-count-v4.7z',
        creates      => 'C:\pwned-passwords-sha1-ordered-by-count-v4.txt',
        require      => Download_file['Download PwnedPasswordDLL'],
      }
      archive {'pwned-passwords-sha1-ordered-by-hash-v4':
        path         => 'C:\pwned-passwords-sha1-ordered-by-hash-v4.7z',
        extract      => true,
        extract_path => 'C:/',
        source       => 'https://downloads.pwnedpasswords.com/passwords/pwned-passwords-sha1-ordered-by-hash-v4.7z',
        creates      => 'C:\pwned-passwords-sha1-ordered-by-hash-v4.txt',
        require      => Archive['pwned-passwords-sha1-ordered-by-count-v4.txt'],
      }
    }
  }
  else {
    notify {"Your operating system: ${::osfamily} is not supported":}
  }
}
