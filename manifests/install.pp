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
        url                   => 'https://github.com/JacksonVD/PwnedPasswordsDLL-API/releases/download/v1.0/PwnedPasswordsDLL-API.dll',
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
        url                   => 'https://github.com/JacksonVD/PwnedPasswordsDLL/releases/download/2.1/PwnedPasswordsDLL.dll',
        destination_directory => 'C:\Windows\system32',
        require               => Exec['TLS-Fix'],
      }
      archive {'pwned-passwords-ntlm-ordered-by-count.txt':
        path         => 'C:\pwned-passwords-ntlm-ordered-by-count.7z',
        extract      => true,
        extract_path => 'C:/',
        source       => 'https://downloads.pwnedpasswords.com/passwords/pwned-passwords-ntlm-ordered-by-count.7z',
        creates      => 'C:\pwned-passwords-ntlm-ordered-by-count.txt',
        require      => Download_file['Download PwnedPasswordDLL'],
      }
      archive {'pwned-passwords-ordered-by-hash':
        path         => 'C:\pwned-passwords-ordered-by-hash.7z',
        extract      => true,
        extract_path => 'C:/',
        source       => 'https://downloads.pwnedpasswords.com/passwords/pwned-passwords-ordered-by-hash.7z',
        creates      => 'C:\pwned-passwords-ordered-by-hash.txt',
        require      => Archive['pwned-passwords-ntlm-ordered-by-count.txt'],
      }
      archive {'pwned-passwords-ordered-by-count':
        path         => 'C:\pwned-passwords-ordered-by-count.7z',
        extract      => true,
        extract_path => 'C:/',
        source       => 'https://downloads.pwnedpasswords.com/passwords/pwned-passwords-ordered-by-count.7z',
        creates      => 'C:\pwned-passwords-ordered-by-count.txt',
        require      => Archive['pwned-passwords-ordered-by-hash'],
      }
    }
  }
  else {
    notify {"Your operating system: ${::osfamily} is not supported":}
  }
}
