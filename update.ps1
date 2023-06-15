$global:path = Split-Path ($MyInvocation.MyCommand.Path) -Parent 

Set-TimeZone "Eastern Standard Time"

if((Get-Service -Name W32Time).Status -eq "Stopped"){
    net start w32time
}


if (!
    #current role
    (New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    #is admin?
    )).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
) {
    #elevate script and exit current non-elevated runtime
    Start-Process `
        -FilePath 'powershell' `
        -ArgumentList (
            #flatten to single array
            '-File', $MyInvocation.MyCommand.Source, $args `
            | %{ $_ }
        ) `
        -Verb RunAs
    exit
}

function Update-Windows
{
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module PSWindowsUpdate -Force

    Get-WindowsUpdate -AcceptAll -Install -AutoReboot

}

function Install-TV
{
    $global:installer += "winget install TeamViewer.TeamViewer.Host --scope machine`n"

}

Install-TV

powershell ($global:path + "\decrapify.ps1")
powershell ($global:path + "\CleanupApps.ps1")


Update-Windows