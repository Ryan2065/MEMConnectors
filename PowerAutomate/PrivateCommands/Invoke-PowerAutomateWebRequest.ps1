Function Invoke-PowerAutomateWebRequest {
    Param(
        [string]$Path,
        [string]$Method = 'Get',
        [string]$Body,
        [switch]$FlowRequest,
        [string]$QueryParams
    )
    if( 
        ($null -eq $Script:PowerAutomateToken) -or
        ($Script:PowerAutomateToken.ExpiresOn -lt ( [DateTime]::UtcNow ))
    ){
        Initialize-PowerAutomate -PromptBehavior SelectAccount
    }
    $Settings = Get-PowerAutomateSettings
    $URI = "$($settings.PowerAppsBase)/$($Settings.PowerAppsBasePath)/$($Path)?api-version=$($Settings.PowerAppsVersion)&$($QueryParams)"
    if($FlowRequest) {
        $Uri = "$($settings.FlowBase)/$($Settings.FlowBasePath)/$($Path)?api-version=$($Settings.FlowVersion)&$($QueryParams)"
    }
    $Header = @{
        'Authorization' = "Bearer $($Script:PowerAutomateToken.AccessToken)"
        "Content-Type" = "application/json"
    }
    
    $InvokeRestHash = @{
        'Method' = $Method
        'URI' = $Uri
        'Headers' = $Header
    }
    if(-not ( [string]::IsNullOrEmpty($Body) )){
        $InvokeRestHash['Body'] = $Body
    }
    Invoke-RestMethod @InvokeRestHash
}