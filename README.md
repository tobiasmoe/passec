# OUTDATED


# Passec


#### Table of Contents

1. [Description](#description)
2. [Setup](#setup)
    * [What passec affects](#what-passec-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with passec](#beginning-with-passec)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference](#Reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures Jacksons Van Dyke's Active Directory Pwned Password integration. You can read more about him and the installation in his blogpost at https://jacksonvd.com/checking-for-breached-passwords-ad-using-k-anonymity/ .

Pwned Passwords are about 500 million real world passwords that have been previously breached in data breaches. This makes these passwords unsuitable and insecure for use. This module is meant to be used against and Active Directory in order to secure users by letting them know if their password has been breached. It is also worth mentioning that the Pwned Password integration only catches Password Change Requests in your Active Directory, meaning it will NOT go through the AD's current user passwords. 

## Setup

### What passec affects
 * Adds a value to following registry key "HKLM\System\CurrentControlSet\Control\LSA\Notification Packages"
 * Ensures that "Password must meet complexity requirements" is enabled on your domain
 * Installs the dll to your C:\windows\system32
 * Installs the database containing all breached passwords to your C:\ (this is optional) 
 
 Please be aware that the module overwrites the registry value for HKLM\System\CurrentControlSet\Control\LSA\Notification Packages. If you wan't to keep what you already have then you have to add it to the variable "registry_values_api" if you're using the API or "registry_values" if you want to download the database locally. 
 
### Setup Requirements

This module is dependant on the following modules
 * puppetlabs/powershell
 * puppet/download_file
 * puppetlabs/registry
 * puppetlabs/reboot
 * puppet/archive
 * puppetlabs/stdlib

### Beginning with passec

If you want to install the module with basic setup,
```
class { '::passec':
   domain_name => 'YourDomainName',
   }
```

By using the basic setup the module will install using the API version of Jacksons code and it will restart your Active Directory and the PC(s). 

## Usage

#### Install and Configure with the basic setup
```
class { '::passec':
   domain_name => 'YourDomainName',
}
```

####  Don't want to restart the PC or Active Directory right now?
```
class { '::passec': 
   domain_name => 'YourDomainName'
   reboot      => false,
   restartadds => false,
}
```
Please keep in mind that you need to eventually restart your PC and Active Directory in order for the module to work. 

####  If you wan't to download it locally instead of using the API version
```
class { '::passec':
   domain_name => 'YourDomainName',
   api         => false,
}

```

You will need at least 60GB of space on your C drive if you want to install it locally.

The download for the local version is quite large, so place keep in mind it will take a long time to download it.
#### If you want to add additional values to the registry key for the API version
```
class { '::passec':
   registry_values_api  => ['PwnedPasswordsDLL-API', 'rassfm', 'scecli'],
   domain_name          => 'YourDomainName',
}
```
Please keep in mind that you need to always include the "PwnedPasswordsDLL-API" to the registry_values_api for the module to work.
#### If you want to add additional values to the registry key for the local version
```
class { '::passec':
   registry_values => ['PwnedPasswordsDLL', 'rassfm', 'scecli'],
   domain_name     => 'YourDomainName',
}
```
#### Most advanced use of the module
```
class { '::passec':
   registry_values => ['PwnedPasswordsDLL', 'rassfm', 'scecli'],
   domain_name     => 'YourDomainName',
   reboot          => false,
   restartadds     => false,
   api             => false,
}
```
## Reference

### Classes

#### Public Classes

* passec: Main class which includes the other classes

#### Private Classes

* passec::install: Installs the necessary files
* passec::config: Configures the module

### Parameters


**api**

Choose whether to use API to query password or download the breached database locally. 

Defaults to true


**restartadds**

Choose whether to restart the Active Directory Domain Service.

Defaults to true


**reboot**

Choose whether to restart the PC.

Defaults to true


**domain_name**

Specify the domain name to ensure that "Passwords must mee complexity requirements" is enabled.

Needs to be string


**registry_values**

Specifies the values that needs to be in the "HKLM\System\CurrentControlSet\Control\LSA\Notification Packages" for the local database installation.

Need to always include "PwnedPasswordsDLL"

Defaults to ['PwnedPasswordsDLL','rassfm','scecli']


**registry_values_api**

Specifies the values that needs to be in the "HKLM\System\CurrentControlSet\Control\LSA\Notification Packages" for the API installation.

Needs to always include "PwnedPasswordsDLL-API"

Defaults to ['PwnedPasswordsDLL-API','rassfm','scecli']



## Limitations

* You need to specify the domain_name
* If you choose to add registry_values then you need to make sure that you're adding the "PwnedPasswordDLL" if you're using the local version, or "PwnedPasswordDLL-API" if you're using the API version.
* This module only works on Windows


## If you want to contribute

You are very welcome to clone the repo to make improvements on your own, just make sure to link back to this repo.

You can also fork the repo and push code to it, then make a pull request to create new functionalites or fix issues. All code needs to follow the puppet style guide and make sure the added code passes the tests.

## Whats next?

* A functinality I would add is to have a customized message that tells you the password you are trying to set is a breached password from the haveibeenpwned website.
* Create more tests! 
