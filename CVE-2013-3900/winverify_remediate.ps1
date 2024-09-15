<#
.DESCRIPTION
    Below Powershell script will Check the existence of registry Key.
    Author: Pralaya Panta
    Version: 1.0.1
#>


#function with parameters path, keyname and value; sets keyValue
Function setRegistryValue {
    param (
        [string]$regPath,
        [string]$keyName,
        [string]$keyValue
    )

    #set the value for the path
    Set-ItemProperty -Path $regPath -Name $keyName -value $keyValue
}

#function with parameter path; creates new path
Function createRegistryPath {
    param (
        [string]$regPath
    )

    #create the new path forced
    New-Item -Path $regPath -Force
}


#reg1 function call
createRegistryPath -regPath "HKLM:\Software\Microsoft\Cryptography\Wintrust"
createRegistryPath -regPath "HKLM:\Software\Microsoft\Cryptography\Wintrust\Config"
setRegistryValue -regPath "HKLM:\Software\Microsoft\Cryptography\Wintrust\Config" -keyName "EnableCertPaddingCheck" -keyValue "1"


#reg2 function call
createRegistryPath -regPath "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust"
createRegistryPath -regPath "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config"
setRegistryValue -regPath "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config" -keyName "EnableCertPaddingCheck" -keyValue "1"

