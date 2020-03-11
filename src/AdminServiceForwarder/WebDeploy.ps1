& "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\msbuild.exe" C:\users\Ryan2\OneDrive\Code\MEMConnectors\src\AdminServiceForwarder\AdminServiceForwarder\AdminServiceForwarder.csproj "/p:DeployOnBuild=true" "/p:PublishProfile=WebDeploy" "/p:EnableMSDeployAppOffline=true"

Get-ChildItem 'C:\Users\Ryan2\OneDrive\Code\MEMConnectors\src\AdminServiceForwarder\AdminServiceForwarder\bin\WebDeploy' | ForEach-Object {
     Copy-Item $_.FullName '\\Lab-CM.Home.Lab\c$\Prestage\' -Force
}

Invoke-COmmand -ComputerName 'Lab-CM.Home.Lab' -ScriptBlock {
    Stop-Website -Name 'AdminServiceForwarder'
    Stop-WebAppPool -Name 'AdminServiceForwarder'
    Start-Sleep 1
    cmd /c C:\Prestage\AdminServiceForwarder.deploy.cmd /y
    Start-WebAppPool -Name 'AdminServiceForwarder'
    Start-Website -Name 'AdminServiceForwarder'
}

if(-not $cred){
    $cred = Get-Credential
}

Invoke-RestMethod 'https://Lab-Cm.Home.Lab:9900/AdminService/wmi/SMS_R_System' -Credential $cred
$MACAddress = '00:11:22:33:44:55'
$DeviceName = 'MyDevice123'
$Body = @{ MACAddress = $MACAddress; NetbiosName = $DeviceName } | convertto-json
Invoke-RestMethod 'https://Lab-Cm.Home.Lab:9900/AdminService/wmi/SMS_Site.ImportMachineEntry/' -Method Post -Body $body -ContentType 'application/json' -Credential $cred
