
# passec

Welcome to your new module. A short overview of the generated parts can be found in the PDK documentation at https://puppet.com/pdk/latest/pdk_generating_modules.html .

The README template below provides a starting point with details about what information to include in your README.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with passec](#setup)
    * [What passec affects](#what-passec-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with passec](#beginning-with-passec)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures Jacksons Van Dyke's Active Directory Pwned Password integration. You can read more about him and the installation in his blogpost at https://jacksonvd.com/checking-for-breached-passwords-ad-using-k-anonymity/ .

Pwned Passwords are about 500 million real world passwords that have been previously breached in data breaches. This makes these passwords unsuitable and insecure for use. This module is meant to be used against and Active Directory in order to secure users by letting them know if their password has been breached. It is also worth mentioning that the Pwned Password integration only catches Password Change Requests in your Active Directory, meaning it will NOT go through the AD's current user passwords. 

## Setup

### What passec affects **OPTIONAL**
 * Adds a value to following registry key "HKLM\System\CurrentControlSet\Control\LSA\Notification Packages"
 * Ensures that "Password must meet complexity requirements" is enabled on your domain
 * Installs the dll to your C:\windows\system32
 * Installs the database containing all breached passwords to your C:\ (this is optional) 

Please be aware that the module overwrites the registry value for HKLM\System\CurrentControlSet\Control\LSA\Notification Packages. If you wan't to keep what you already have then you have to add it to the variable "registry_values_api" if you're using the API or "registry_values" if you want to download the database locally. 

### Setup Requirements **OPTIONAL**
This module is depends on the following modules
 * puppetlabs/powershell
 * puppet/download_file
 * puppetlabs/registry
 * puppetlabs/reboot
 * puppetlabs/archive

### Beginning with passec

If you want to install the module with basic setup,
```
class { '::passec':
   domain_name => 'borg.trek',
   }
```

By using the basic setup the module will install using the API version of Jacksons code and it will restart your Active Directory and the PC(s). 

## Usage

# Install and Configure with the basic setup
```
class { '::passec':
   domain_name => 'borg.trek',
}
```

# Don't want to restart the PC or Active Directory right now?

```
class { '::passec': 
   domain_name => 'borg.trek'
   reboot      => false,
   restartadds => false,
}
```

Please keep in mind that you need to eventually restart your PC and Active Directory in order for the module to work. 

# If you wan't to download it locally instead of using the API version
```
class { '::passec':
   domain_name => 'borg.trek',
   api         => false,
}
```

# If you want to add additional values to the registry key for the API version
```
class { '::passec':
   registry_values_api  => ['PwnedPasswordsDLL-API', 'rassfm', 'scecli'],
   domain_name          => 'borg.trek',
}
```
Please keep in mind that you need to always include the "PwnedPasswordsDLL-API" to the registry_values_api for the module to work.

# If you want to add additional values to the registry key for the local version
```
class { '::passec':
   registry_values => ['PwnedPasswordsDLL', 'rassfm', 'scecli'],
   domain_name     => 'borg.trek',
}
```

# Most advanced use of the module
```
class { '::passec':
   registry_values => ['PwnedPasswordsDLL', 'rassfm', 'scecli'],
   domain_name     => 'borg.trek',
   reboot          => false,
   restartadds     => false,
   api             => false,
}
```

## Reference

This section is deprecated. Instead, add reference information to your code as Puppet Strings comments, and then use Strings to generate a REFERENCE.md in your module. For details on how to add code comments and generate documentation with Strings, see the Puppet Strings [documentation](https://puppet.com/docs/puppet/latest/puppet_strings.html) and [style guide](https://puppet.com/docs/puppet/latest/puppet_strings_style.html)

If you aren't ready to use Strings yet, manually create a REFERENCE.md in the root of your module directory and list out each of your module's classes, defined types, facts, functions, Puppet tasks, task plans, and resource types and providers, along with the parameters for each.

For each element (class, defined type, function, and so on), list:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

For example:

```
### `pet::cat`

#### Parameters

##### `meow`

Enables vocalization in your cat. Valid options: 'string'.

Default: 'medium-loud'.
```

## Limitations

* You need to specify the domain_name
* If you choose to add registry_values then you need to make sure that you're adding the "PwnedPasswordDLL" if you're using the local version, or "PwnedPasswordDLL-API" if you're using the API version.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
