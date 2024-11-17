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

Function DownloadAgent{
    Write-Output "Downloading the agent file now"

    try {
        Invoke-WebRequest -Uri $MARSAgentDownloadUrl -OutFile $TempDownloadPath -ErrorAction Stop
        return $TempDownloadPath
    } catch {
        Write-Error "Failed to download the MARS agent installer. Error: $_"
        return $null
    }
}

#check the registry for the path
If (Test-path $RegPath){
    Write-Output "Azure MARS agent is installed and will update"
    $AgentDownloadpath = DownloadAgent #calls the function to download the agent
    Write-Output $AgentDownloadpath

    $arglist = '/q'
    [String]$filePathString = $TempDownloadPath
    #executing the downloaded exe file
    Start-Process -FilePath $filePathString -ArgumentList $arglist -Wait -ErrorAction Stop
}else {
    Write-Output "Azure MARS agent is not installed. No further actions will be taken."
}

# Cleanup downloaded installer
if (Test-Path $TempDownloadPath) {
    Remove-Item -Path $TempDownloadPath -Force
    Write-Output "Temporary installer file has been deleted."
}