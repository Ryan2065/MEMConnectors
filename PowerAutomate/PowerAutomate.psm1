$Commands = Get-ChildItem "$PSScriptRoot\Commands" -Filter '*.ps1'
Foreach($command in $commands) {
    . $command.FullName
}

$PrivateCommands = Get-ChildItem "$PSScriptRoot\PrivateCommands" -Filter '*.ps1'
Foreach($command in $PrivateCommands) {
    . $command.FullName
}

Export-ModuleMember -Function $Commands.BaseName