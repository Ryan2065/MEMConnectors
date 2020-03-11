Function Initialize-PowerAutomate {
    Param(
        [ValidateSet('Always', 'Auto', 'Never', 'RefreshSession', 'SelectAccount')]
        [string]$PromptBehavior = 'Auto'
    )
    $Settings = Get-PowerAutomateSettings
    $AdalHash = @{
        'TenantId' = $Settings.Tenant
        'Authority' = $Settings.Authority
        'Resource' = $Settings.Resource
        'ClientId' = $Settings.ClientId
        'PromptBehavior' = $PromptBehavior
    }
    $Script:PowerAutomateToken = Get-adalToken @AdalHash
    
}