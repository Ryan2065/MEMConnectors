$authority = 'https://login.microsoftonline.com/common'
$resource = 'https://management.core.windows.net/'
$tenant = 'common'
$ClientId = '04b07795-8ddb-461a-bbee-02f9e1bf7b46'

$FlowAPI = 'https://api.flow.microsoft.com'
$FlowVersion = '2016-11-01'
$FlowBasePath = 'providers/Microsoft.ProcessSimple'

$token = Get-adalToken -TenantId $tenant -Authority $authority -Resource $resource -ClientId $ClientId -PromptBehavior SelectAccount

$Headers = @{
    'Authorization' = "Bearer $($token.AccessToken)"
    "Content-Type" = "application/json"
}

$Environments = Invoke-RestMethod -Method 'Get' -Uri "$FlowAPI/$($FlowBasePath)/environments?api-version=$($FlowVersion)" -Headers $Headers
$Ennvironment
if($environments.Count -ne 1){

}