Param(
    [Parameter(Mandatory=$true)]
    [string]$ClientId,
    [Parameter(Mandatory=$true)]
    [string]$ClientSecret,
    [Parameter(Mandatory=$true)]
    [ValidateSet("Intune", "ConfigMgr")]
    [string]$Connector
)

Set-Location "$PSScriptRoot\$Connector"

$apiPropertiesContent = Get-Content "apiProperties.json" -Raw

$correctAPIPropertiesContent = $apiPropertiesContent.Replace('{{replace_with_your_client_id}}', $ClientId)
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
Remove-Item apiProperties.json -Force -ErrorAction SilentlyContinue
[System.IO.File]::WriteAllLines("$PSScriptRoot\$Connector\apiProperties.json", $correctAPIPropertiesContent, $Utf8NoBomEncoding)

paconn create --api-def apiDefinition.swagger.json --api-prop apiProperties.json --secret "$ClientSecret"

#cleanup
Remove-Item apiProperties.json -Force -ErrorAction SilentlyContinue
[System.IO.File]::WriteAllLines("$PSScriptRoot\$Connector\apiProperties.json", $apiPropertiesContent, $Utf8NoBomEncoding)
