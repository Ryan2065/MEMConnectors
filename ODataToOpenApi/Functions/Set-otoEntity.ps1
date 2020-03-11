Function Set-otoEntity{
    Param(
        [string]$EntityName,
        [string]$DefinitionName,
        [switch]$ResponseInValueProperty = $false,
        [switch]$ArrayResponse = $false,
        [string]$MetadataPath,
        [string]$SwaggerPath
    )
    [xml]$md = Get-Content "$MetadataPath" -raw

    $objProperties = Get-otoObject -objectName $EntityName -metadata $md -ResponseInValueProperty:$ResponseInValueProperty -ArrayResponse:$ArrayResponse

    $swaggerJson = Get-Content $SwaggerPath -raw
    $global:SwaggerObject = ConvertFrom-Json $swaggerJson
    if($null -eq $SwaggerObject.definitions) {
        $SwaggerObject.definitions = @{}
    }
    if($null -eq $SwaggerObject.definitions."$DefinitionName"){
        $SwaggerObject.definitions | Add-Member -MemberType NoteProperty -Name $DefinitionName -Value $objProperties
    }

    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($SwaggerPath, ($SwaggerObject | ConvertTo-JSON -Depth 100), $Utf8NoBomEncoding)
}