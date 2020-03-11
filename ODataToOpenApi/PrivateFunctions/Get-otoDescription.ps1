Function Get-otoDescription{
    Param(
        [string]$ObjectName,
        $Annotations
    )
    
    $GraphObjectName = "microsoft.graph.$($ObjectName)"
    foreach($Annotation in $Annotations) {
        if($Annotation.Target -eq $GraphObjectName){
            $ann = $Annotation.Annotation
            if($ann.Term -like '*.Description') {
                return @($ann.String)[0]
            }
        }
    }
    $EntityName = $ObjectName.Split('/')[0]
    if($EntityName -ne $ObjectName){
        $PropertyName = $ObjectName.Split('/')[1]
    }
    if([string]::IsNullOrEmpty($PropertyName)){
        return
    }
    $Url = "https://docs.microsoft.com/en-us/configmgr/develop/reference/core/clients/manage/$($EntityName)-server-wmi-class"
    $wr = invoke-restmethod $url
    $Lines = $wr.Split([System.Environment]::NewLine)
    $FoundProps = $false
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $line = $lines[$i]
        if($FoundProps) {
            if($line.Contains('<p>') -and $lines[$i+1].ToLower().Contains("<code>$($PropertyName.ToLower())</code>")){
                $maxCount = 20
                $count = 0
                while($count -lt $maxCount){
                    if($lines[$i + $count].contains('<p>Qualifiers')){

                        $Description = $lines[($i + $count + 1)]
                        if($Description.Contains('</p>')){
                            $Description = $Description.Trim().Replace('<p>','').Replace('</p>','').Replace('<code>','').Replace('</code>','')
                            return $Description
                        }
                        elseif($Description.Contains('<p>')){
                            write-host 'here'
                            $Description = $lines[($i + $count + 2)]
                            write-host $Description
                            return $Description
                        }
                    }
                    $count++
                }
            }
        }
        if($line.Contains('id="properties"')){
            $FoundProps = $true
        }
    }
}