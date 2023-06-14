$global:path = Split-Path ($MyInvocation.MyCommand.Path) -Parent 

function Update-Windows
{
    $global:installer += "`nInstall-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force`n"
    $global:installer += "Install-Module PSWindowsUpdate -Force`n"

    $global:installer += "Get-WindowsUpdate -AcceptAll -Install`n" #-AutoReboot

}


copy ($global:path + "\Layout.xml ") "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayout.xml"
powershell ($global:path + "\decrapify.ps1")
powershell ($global:path + "\CleanupApps.ps1")


Update-Windows