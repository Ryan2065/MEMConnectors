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

$BinLocation = "$PSScriptRoot\bin\$Connector"
$ConnectorLocation = "$PSScriptRoot\$Connector"

if(-not (Test-Path $BinLocation)){
    $null = New-Item -Path $BinLocation -ItemType Directory -Force
}
else{
    $null = Remove-Item -Path "$BinLocation\apiProperties.json" -Force -ErrorAction SilentlyContinue
    $null = Remove-Item -Path "$BinLocation\apiDefinition.swagger.json" -Force -ErrorAction SilentlyContinue
}

$apiPropertiesContent = Get-Content "$ConnectorLocation\apiProperties.json" -Raw
$apiDefinition = Get-Content "$ConnectorLocation\apiDefinition.swagger.json" -Raw

$correctAPIPropertiesContent = $apiPropertiesContent.Replace('{{replace_with_your_client_id}}', $ClientId)
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

[System.IO.File]::WriteAllLines("$BinLocation\apiProperties.json", $correctAPIPropertiesContent, $Utf8NoBomEncoding)
[System.IO.File]::WriteAllLines("$BinLocation\apiDefinition.swagger.json", $apiDefinition, $Utf8NoBomEncoding)

Set-Location $BinLocation

$RanCommand = $false
if(Get-Command 'paconn.exe' -ErrorAction SilentlyContinue){
    $RanCommand = $true
    if($update){
        paconn update --api-def apiDefinition.swagger.json --api-prop apiProperties.json --secret "$ClientSecret" 2>&1 | Tee-Object -Variable response
        if($response.ToString().Contains('Access token invalid')){
            paconn login
            paconn update --api-def apiDefinition.swagger.json --api-prop apiProperties.json --secret "$ClientSecret"
        }
    }
    else {
        paconn create --api-def apiDefinition.swagger.json --api-prop apiProperties.json --secret "$ClientSecret" 2>&1 | Tee-Object -Variable response
        if($response.ToString().Contains('Access token invalid')){
            paconn login
            paconn create --api-def apiDefinition.swagger.json --api-prop apiProperties.json --secret "$ClientSecret"
        }
    }
}

if($false -eq $RanCommand){
    throw "Paconn is not installed. This will require Python be installed on this computer. Please see ReadMe for instructions. Paconn documentation located at: https://pypi.org/project/paconn/"
}

Set-Location $CurrentLocation