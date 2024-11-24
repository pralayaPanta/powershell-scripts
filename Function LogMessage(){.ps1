Function LogMessage(){

    param (
        [Parameter(Mandatory=$true)][String]$logtext,
        [Parameter(Mandatory=$true)][String]$logfilepath
    )

    try {
        Add-content -Path  $LogFilePath -Value $logtext
        Write-host "Message: '$logtext' Has been Logged to File: $logfilepath" -f Yellow

    }
    catch {
        <#Do this if a terminating exception happens#>
        Write-host -f Red "Error:" $_.Exception.Message
    }


 
}
$logfilepath = "C:\Temp\AppLog.txt"

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
 
LogMessage "Script2 Started at: $(Get-date -format 'dd/MM/yyy hh:mm:ss tt')" -logfilepath $logfilepath
