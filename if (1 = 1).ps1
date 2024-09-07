$var1 = 1
$var2 = 2

if ($var1 -eq $var2){
       # Write-Output "The registry key is set to the expected value"
        exit 0
} else {
       # Write-Output "The registy key is not set to the expected value - needs remediation"
        exit 1
}