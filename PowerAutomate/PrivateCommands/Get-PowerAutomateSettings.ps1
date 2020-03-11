Function Get-PowerAutomateSettings{
    $SettingsFile = "$(( Get-Item $PSScriptRoot ).Parent.FullName)\PowerAutomateSettings.json"
    $SettingsJsonObject = Get-Content $SettingsFile | ConvertFrom-JSON
    return $SettingsJsonObject
}