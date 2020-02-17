Param([string]$ObjectType = 'managedDevice')

$Functions = Get-ChildItem "$PSScriptRoot\Functions" -Filter '*.ps1'
foreach($fun in $functions){
    . $fun.fullname
}

[xml]$md = Get-Content "$PSScriptRoot\metadata.xml" -raw
#$EntityTypes = $md.edmx.DataServices.Schema.EntityType
#$Enums = $md.edmx.DataServices.Schema.EnumType
#$global:Annotations = $md.edmx.DataServices.Schema.Annotations


$ReturnObject = @{}

$ReturnObject[$ObjectType] = Get-memODataObject -objectName $ObjectType -metadata $md

return $ReturnObject