Function Get-PowerAutomateConnectors {
    Param(
        [string]$Environment,
        [switch]$CustomApi
    )
    #$ConnectorId = "/$ConnectorId"
    $QueryParams = "`$filter=environment eq '$($Environment)'"
    
    $response = Invoke-PowerAutomateWebRequest -Path "apis/$($ConnectorId)" -QueryParams $QueryParams
    if($response.Value) {
        if($CustomApi){
            foreach($c in $response.Value){
                if($c.Properties.isCustomApi -eq $true){
                    $c
                }
            }
        }
        else{
            return $response.Value
        }
        return
    }
    return $Response
}