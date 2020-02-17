Function Get-otoObject{
    Param(
        [string]$ObjectName,
        $metadata,
        [bool]$IsRoot = $true, 
        [switch]$ResponseInValueProperty,
        [switch]$ArrayResponse
    )
    $EntityTypes = $metadata.edmx.DataServices.Schema.EntityType
    $returnObject = @{}
    $Found = $false
    $EntityAndComplexTypes = $EntityTypes
    $EntityAndComplexTypes += $metadata.edmx.DataServices.Schema.ComplexType
    foreach($et in $EntityAndComplexTypes) {
        if($et.Name -eq $ObjectName) {
            $found = $true
            $returnObject = @{
                'type' = 'object'
            }
            if($IsRoot){
                $returnObject['title'] = $et.Name
            }
            $des = Get-otoDescription -ObjectName $et.Name -Annotations $metadata.edmx.DataServices.Schema.Annotations
            if(-not [string]::IsNullOrEmpty($des)){
                if(@($des).Count -gt 1){
                    $des = $des[0]
                }
                $returnObject['description'] = $des
            }

            $AllProperties = Get-otoProperties -metadata $metadata -Entity $et

            if($ResponseInValueProperty){
                if($ArrayResponse){
                    $returnObject['properties'] = @{
                        'value' = @{
                            'type' = 'array'
                            'items' = @{
                                'type' = 'object'
                                'properties' = $AllProperties
                            }
                        }
                    }
                }
                else{
                    $returnObject['properties'] = @{
                        'value' = @{
                            'type' = 'object'
                            'properties' = $AllProperties
                        }
                    }
                }
            }
            elseif($ArrayResponse){
                $returnObject['properties'] = @{
                    'type' = 'array'
                    'items' = @{
                        'type' = 'object'
                        'properties' = $AllProperties
                    }
                }
            }
            else {
                $returnObject['properties'] = $AllProperties
            }
        }
    }
    if($false -eq $found){
        $Enums = $md.edmx.DataServices.Schema.EnumType
        foreach($enum in $enums){
            if($enum.Name -eq $ObjectName) {
                $found = $true
                $returnObject['type'] = 'string'
                $returnObject['format'] = 'enum'
                $returnObject['enum'] = @($enum.Member.Name)
            }
        }
    }
    return $returnObject
}