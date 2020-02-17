Function Get-otoDescription{
    Param(
        [string]$ObjectName,
        $Annotations
    )
    
    $ObjectName = "microsoft.graph.$($ObjectName)"
    foreach($Annotation in $Annotations) {
        if($Annotation.Target -eq $ObjectName){
            $ann = $Annotation.Annotation
            if($ann.Term -like '*.Description') {
                return @($ann.String)[0]
            }
        }
    }
}