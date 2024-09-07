<#
.DESCRIPTION
    Below Powershell script will Check the existence of registry Key.
    Author: Pralaya Panta
    Version: 1.0.1
#>


#function with parameters path, keyname and value
Function compareRegistryValue {
    param (
        [string]$regPath,
        [string]$keyName,
        [string]$keyValue
    )

    #check and get the current value
    $currentValue = (Get-ItemProperty -Path $regPath -Name $keyName).$keyName

    if ($currentValue -eq $keyValue) { #compare the current value to desired
        return $true
    } else {
        return $false
    }
}

#call the function with the parameter
$reg1 = compareRegistryValue -regPath "HKLM:\Software\Microsoft\Cryptography\Wintrust\Config" -keyName "EnableCertPaddingCheck" -keyValue "1"
$reg2 = compareRegistryValue -regPath "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config" -keyName "EnableCertPaddingCheck" -keyValue "1"

#checks if both are true and exits
if ($reg1 -and $reg2){
        Write-Output "The registry key is set to the expected value"
        exit 0
} else {
        Write-Output "The registy key is not set to the expected value - needs remediation"
        exit 1
}