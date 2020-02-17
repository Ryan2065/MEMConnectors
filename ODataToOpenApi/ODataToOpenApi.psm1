$Functions = Get-ChildItem "$PSScriptRoot\PrivateFunctions" -Filter '*.ps1'
foreach($fun in $functions){
    . $fun.fullname
}


$Functions = Get-ChildItem "$PSScriptRoot\Functions" -Filter '*.ps1'
foreach($fun in $functions){
    . $fun.fullname
}


Export-ModuleMember -Function $Functions.BaseName