$global:path = Split-Path ($MyInvocation.MyCommand.Path) -Parent 




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

Set-TimeZone "Eastern Standard Time"

if((Get-Service -Name W32Time).Status -eq "Stopped"){
    net start w32time
}

w32tm /resync /force

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
function Change-Power-Settings
{
    powercfg /Change monitor-timeout-ac 10

    powercfg /Change standby-timeout-ac 0
}

function InstallWinget{

    if(-Not (Get-Command winget -errorAction SilentlyContinue)){
        Add-AppxPackage 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
        Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile ($global:path + '\WinGet.msixbundle')
        Add-AppxPackage ($global:path + '\WinGet.msixbundle')
        Remove-Item ($global:path + '\Winget.msixbundle')
    }

    #Random winget cmd used to accept agreements
    winget search --accept-source-agreements Acc > $null
}

function NetworkTest{

    param(
        [bool] $CheckNetwork = 1
    )
    if($CheckNetwork){
        
        if(-Not (Test-Connection -ComputerName 1.1.1.1 -Quiet -ErrorAction SilentlyContinue)){
            "Error: Please check your internet connection"
        }else{
            Write-Output "SSD DETECTED"
            return
        }

    }


    Write-Host "`nr: Retry"
    Write-Host "q: Quit"

    $selection = Read-Host "Enter your selection"
    
    switch -Regex ($selection){
        "r"{NetworkTest;return}
        "q"{exit}
        "^*"{"Ivalid Option";NetworkTest -CheckNetwork 0}
    }


}
function CheckDrive{
    
    $disk = Get-PhysicalDisk
    
    if($disk.MediaType -eq "HDD"){
        Write-Output "`nWARNING: HDD DETECTED.`nProceed?"

        $selection = Read-Host "Enter: Y(Yes) or N(No)"
        switch -Regex ($selection){
            'y'{return}
            'n'{exit}
            '^*'{'Invalid Option';CheckDrive}
            
        }
    }else{
        return
    }
}

CheckDrive
NetworkTest
Change-Power-Settings

Install-TV

InstallWinget

powershell $global:path + "\dependencies\decrapify.ps1"
powershell $global:path + "\dependencies\CleanupApps.ps1"


Update-Windows