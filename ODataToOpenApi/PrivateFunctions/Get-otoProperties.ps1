Function Get-otoProperties {
    Param(
        $metadata,
        $Entity
    )
    $returnObject = @{}
    if($entity.BaseType){
        $BaseNameArray = $entity.BaseType.Split('.')
        $BaseName = $BaseNameArray[($BaseNameArray.count - 1)]
        $BaseObject = Get-otoObject -ObjectName $BaseName -metadata $metadata -IsRoot $false
        foreach($key in $BaseObject.properties.keys) {
            $returnObject[$key] = $BaseObject.properties[$key]
        }
    }
    foreach($prop in $Entity.property){
        $propObj = @{}
        if($prop.Name.StartsWith('__')){
            continue;
        }
        #region Description
        $descriptionpath = "$($Entity.Name)/$($prop.Name)"
        $strDes = Get-otoDescription -ObjectName $descriptionpath -Annotations $metadata.edmx.DataServices.Schema.Annotations
        if([string]::IsNullOrEmpty($strDes)){
            $strDes = "$($prop.Name)-TOCHANGE"
        }
        $propObj['description'] = $strDes
        #endregion
        if($prop['Nullable'] -ne 'false'){
            $propObj['x-nullable'] = 'true'
        }
        switch -Wildcard ($prop.Type){
            "Edm.String" {
                $propObj['type'] = 'string'
                
                break;
            }
            "Edm.DateTimeOffset" {
                $propObj['type'] = 'string'
                $propObj['format'] = 'timestamp'
                break;
            }
            "Edm.Boolean"{
                $propObj['type'] = 'boolean'
            }
            "Edm.Binary"{
                $propObj['type'] = 'string'
                $propObj['format'] = 'binary'
                break;
            }
            "Edm.Int64"{
                $propObj['type'] = 'integer'
                $propObj['format'] = 'int64'
            }
            "Edm.Int32"{
                $propObj['type'] = 'integer'
                $propObj['format'] = 'int32'
            }
            "graph.*"{
                $NameToGet = $prop.type.Split('.')[1]
                $propObj = Get-otoObject -ObjectName $NameToGet -metadata $metadata -IsRoot $false
                break;
            }
            "SCCMGraph.*"{
                $NameToGet = $prop.type.Split('.')[1]
                $propObj = Get-otoObject -ObjectName $NameToGet -metadata $metadata -IsRoot $false
                break;
            }
            "Collection(*"{
                $ColType = $prop.Type.Split('(')[1].Split(')')[0]
                $propObj['type'] = 'array'
                $items = @{}
                switch -Wildcard ($ColType){
                    "Edm.String" {
                        $items['type'] = 'string'
                        break;
                    }
                    "Edm.DateTimeOffset" {
                        $items['type'] = 'string'
                        $items['format'] = 'timestamp'
                        break;
                    }
                    "Edm.Boolean"{
                        $items['type'] = 'boolean'
                    }
                    "Edm.Binary"{
                        $propObj['type'] = 'string'
                        $propObj['format'] = 'binary'
                        break;
                    }
                    "Edm.Int64"{
                        $items['type'] = 'integer'
                        $items['format'] = 'int64'
                    }
                    "Edm.Int32"{
                        $items['type'] = 'integer'
                        $items['format'] = 'int32'
                    }
                    "graph.*"{
                        $NameToGet = $ColType.Split('.')[1]
                        $items = Get-otoObject -ObjectName $NameToGet -metadata $metadata -IsRoot $false
                        break;
                    }
                    "SCCMGraph.*"{
                        $NameToGet = $prop.type.Split('.')[1]
                        $propObj = Get-otoObject -ObjectName $NameToGet -metadata $metadata -IsRoot $false
                        break;
                    }
                }
                $propObj['items'] = $items
                break;
            }
            Default{
                Write-Warning "Could not find type $($prop.Type)"
                throw
            }
        }
        $returnObject[$prop.Name] = $propObj
    }
    return $returnObject
}