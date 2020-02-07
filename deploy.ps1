Param(
    [Parameter(Mandatory=$true)]
    [string]$ClientId,
    [Parameter(Mandatory=$true)]
    [string]$ClientSecret,
    [Parameter(Mandatory=$true)]
    [ValidateSet("Intune", "ConfigMgr")]
    [string]$Connector,
    [switch]$Update
)
$CurrentLocation = Get-Location
Set-Location "$PSScriptRoot\$Connector"

$apiPropertiesContent = Get-Content "apiProperties.json" -Raw

$correctAPIPropertiesContent = $apiPropertiesContent.Replace('{{replace_with_your_client_id}}', $ClientId)
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
Remove-Item apiProperties.json -Force -ErrorAction SilentlyContinue
[System.IO.File]::WriteAllLines("$PSScriptRoot\$Connector\apiProperties.json", $correctAPIPropertiesContent, $Utf8NoBomEncoding)

$RanCommand = $false
if(Get-Command 'paconn.exe' -ErrorAction SilentlyContinue){
    $RanCommand = $true
    if($update){
        paconn update --api-def apiDefinition.swagger.json --api-prop apiProperties.json --secret "$ClientSecret"
    }
    else {
        paconn create --api-def apiDefinition.swagger.json --api-prop apiProperties.json --secret "$ClientSecret"
    }
}


#cleanup
Remove-Item apiProperties.json -Force -ErrorAction SilentlyContinue
[System.IO.File]::WriteAllLines("$PSScriptRoot\$Connector\apiProperties.json", $apiPropertiesContent.Trim(), $Utf8NoBomEncoding)

if($false -eq $RanCommand){
    throw "Paconn is not installed. This will require Python be installed on this computer. Please see ReadMe for instructions. Paconn documentation located at: https://pypi.org/project/paconn/"
}

Set-Location $CurrentLocation