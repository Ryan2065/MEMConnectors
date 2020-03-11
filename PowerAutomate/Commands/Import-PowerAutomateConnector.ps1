Function Import-PowerAutomateConnector {
    Param(
        [string]$Environment,
        [string]$PathToapiDefinition,
        [string]$PathToapiProperties
    )
    $apiDefinition = Get-Content $PathToapiDefinition | ConvertFrom-JSON
    $apiProperties = Get-Content $PathToapiProperties | ConvertFrom-JSON
    $ConnectorName = $apiDefinition.info.Title
    $CustomConnectors = Get-PowerAutomateConnectors -Environment $Environment -CustomApi
    $CustomConnector = $null
    foreach($c in $CustomConnectors) {
        if($c.Properties.displayName -eq $ConnectorName){
            $CustomConnector = $c
        }
    }
    
}