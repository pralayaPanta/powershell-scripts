<#
    .SYNOPSIS
        Script that checks existing instalaltion and updates the MARS agent.
    .DESCRIPTION
        This script checks the existing instlaltion of MARS agent in registry
        If the insallation or path exists in registry
        Download the installation file from MS site
        Update the installation
        Cleans up the instllation that was downlaoded

    .NOTES
        Author: Pralaya Panta
        Version: 1.0
        File: Download and update the MARS agent    
#>

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Windows Azure Backup" #registry path
$MARSAgentDownloadUrl = "https://aka.ms/azurebackup_agent"  # This URL redirects to the latest MARS agent download
$TempDownloadPath = "$env:TEMP\MARSAgentInstaller.exe"
$ProgressPreference = 'SilentlyContinue'

Function DownloadAgent{
    Write-Output "Downloading the agent file now"

    try {
        Invoke-WebRequest -Uri $MARSAgentDownloadUrl -OutFile $TempDownloadPath -ErrorAction Stop
        return $TempDownloadPath
    } catch {
        LogMessage "Failed to download the MARS agent installer. Error: $_  $(Get-date -format 'dd/MM/yyy hh:mm:ss tt')" -logfilepath $logfilepath
        return $null
    }
}

Function LogMessage(){
    param (
        [Parameter(Mandatory=$true)][String]$logtext,
        [Parameter(Mandatory=$true)][String]$logfilepath
    )

    try {
        Add-content -Path  $LogFilePath -Value $logtext
        #Write-host "Message: '$logtext' Has been Logged to File: $logfilepath" -f Yellow
    }
    catch {
        <#Do this if a terminating exception happens#>
        Write-host -f Red "Error:" $_.Exception.Message
    }
}

$logfilepath = "C:\Temp\MARS-Agent-Update-Logs.txt"

#Ensure the Parent Folder for Log File
$FolderPath= Split-Path $logfilepath
If(!(Test-Path -path $FolderPath)) 
{ 
    New-Item -ItemType directory -Path $FolderPath | Out-Null
}

#Delete the Log file if exists
If(Test-Path $logfilepath)
{
    Remove-Item $logfilepath
}

DownloadAgent #calls the function to download the agent
$exe_version_raw = (Get-Item $TempDownloadPath).VersionInfo.FileVersion -replace "\.", "" 
$fileVer = [int]$exe_version_raw
Write-Output $fileVer.GetType()

#check the registry for the path
If (Test-path $RegPath){
    LogMessage "Azure MARS agent is installed $(Get-date -format 'dd/MM/yyy hh:mm:ss tt')" -logfilepath $logfilepath
    $regValueVersion_string = Get-ItemPropertyValue -Path $RegPath -Name DisplayVersion
    [int]$regValueVersion = $regValueVersion_string -replace "\.", ""
    LogMessage "Installed Version:$regValueVersion   $(Get-date -format 'dd/MM/yyy hh:mm:ss tt')" -logfilepath $logfilepath
    If ($regValueVersion -ne $fileVer ){
        LogMessage "Available Version: $fileVer $(Get-date -format 'dd/MM/yyy hh:mm:ss tt')" -logfilepath $logfilepath
        $arglist = '/q'
        [String]$filePathString = $TempDownloadPath
        #executing the downloaded exe file
        
        Start-Process -FilePath $filePathString -ArgumentList $arglist -Wait -ErrorAction Stop
    }else {
        # No action here
    }
}else {
    LogMessage "Azure MARS agent is not installed. No further actions will be taken. $(Get-date -format 'dd/MM/yyy hh:mm:ss tt')" -logfilepath $logfilepath
}

# Cleanup downloaded installer
if (Test-Path $TempDownloadPath) {
    Remove-Item -Path $TempDownloadPath -Force
    LogMessage "$TempDownloadPath removed $(Get-date -format 'dd/MM/yyy hh:mm:ss tt')" -logfilepath $logfilepath
}