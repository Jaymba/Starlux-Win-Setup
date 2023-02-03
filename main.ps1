#Common Programs  ID
#Adobe Acrobat:   Adobe.Acrobat.Reader.64-bit
#LibreOffice:     TheDocumentFoundation.LibreOffice
#GnuCash:         GnuCash.GnuCash
#Gimp:            GIMP.GIMP
#GoogleEarthPro   Google.EarthPro
#ImageGlass DuongDieuPhap.ImageGlass
#TypingInstructor


#TO-DO
#Add options to disable sound, video, and images.
#Checkout Plain Connections for list of software

Clear-Host

Set-TimeZone "Eastern Standard Time"

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

function NetworkTest{

    param(
        [bool] $CheckNetwork = 1
    )
    if($CheckNetwork){
        
        if(-Not (Test-Connection -ComputerName 1.1.1.1 -Quiet -ErrorAction SilentlyContinue)){
            "Error: Please check your internet connection"
        }else{
            return
        }

    }


    Write-Host "`nr: Retry"
    Write-Host "q: Quit"

    $selection = Read-Host "Enter your selection"
    
    switch -Regex ($selection){
        "r"{NetworkTest}
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
        Break
    }
}

function Change-Power-Settings
{
    powercfg /Change monitor-timeout-ac 10

    powercfg /Change standby-timeout-ac 120
    

}

function InstallWinget{

    if(-Not (Get-Command winget -errorAction SilentlyContinue)){
        Add-AppxPackage "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
        Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile ".\WinGet.msixbundle"
        Add-AppxPackage ".\WinGet.msixbundle"    
        Remove-Item ".\Winget.msixbundle"
    }

    #Random winget cmd used to accept agreements
    winget search --accept-source-agreements Acc > $null
}


#Append strings to the end of the installer. At the end run installer with Invoke-Expression
$global:installer = ""

$global:path = $MyInvocation.MyCommand.Path | Split-Path -Parent

#Menus

function Rename-Menu{
    $newname = Read-Host "Enter a name for this device"

    Rename-Device -NewName $newname 
}


function Rename-Device
{
    param(
        [string]$NewName
    )

    if((-Not $NewName) -or ($NewName.StartsWith(" ")))
    {
        Write-Output "`nName cannot be empty or start with a space.`nPlease Try Again.`n"
        Rename-Menu
        return
    }

    $confirm = Read-Host "`nThe device name will be:" $newname "`nIs that correct?`nType Y(yes) or N(no)"


    switch -Regex ($confirm){
        'y'{ $global:installer += "Rename-Computer -NewName " + $NewName + "`n";return}
        'n'{Rename-Menu;return}
        '^*'{'ERROR: Unrecognized Option';Rename-Device}
    }
}



function User-Menu{
    $newname = Read-Host "Enter a name for the User"

    Create-User -NewName $newname 
}


function Create-User
{
    param(
        [string]$NewName
    )

    if((-Not $NewName) -or ($NewName.StartsWith(" ")))
    {
        Write-Output "`nName cannot be empty or start with a space.`nPlease Try Again.`n"
        User-Menu
        return
    }

    $confirm = Read-Host "`nThe Username will be:" $newname "`nIs that correct?`nType Y(yes) or N(no)"


    switch -Regex ($confirm){
        'y'{ $global:installer += "`nNew-LocalUser -Name " + $NewName + "`n";break}
        'n'{User-Menu;return}
        '^*'{'ERROR: Unrecognized Option';Create-User}
    }
    Set-Admin $NewName

}

function Set-Admin
{
    param(
        [string] $Name
    )

    $admin = Read-Host "`nSet User as administator?`nType: Y(Yes) or N(No)"

    switch -Regex ($admin){
        'y' { $global:installer += "Add-LocalGroupMember -Group Administrators -Member " + $Name + "`n";return}
        'n' { $global:installer += "Add-LocalGroupMember -Group Users -Member " + $Name + "`n";return}
        '^*'{"Error: Unrecognized Option."; Set-Admin $name}
    }
}    



function GP-Menu
{
    param(
        [string]$Title = 'Select GP'
    )

    Write-Host "`n=========================$Title==========================="

    Write-Host "1: Apply Guardian Group Policy"
    Write-Host "2: No Group Policy"
    Write-Host "q: Quit"
    

    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection)
    {
        '1' {Apply-GP; return} 
        '2' {"`nSkipping Group Policy`n"; return}
        'q' {exit} 
        '^*' {"`nERROR: Unrecognized Option`n"; GP-Menu}
    }
}

function Apply-GP
{
    $GPPath = $global:path + "\GP\*"
    $global:installer += "`nCopy-Item " + $GPpath + " -Destination 'C:\Windows\System32 -Force'`n`n"
}

function Install-TV
{
    winget install TeamViewer.TeamViewer.Host

}


#Discarded in favor of installing TV Host without prompt
function TV-Menu
{
    Write-Host "1: Teamviewer Host"
    Write-Host "2: Teamviewer"

    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection){
        '1' {$global:installer += "winget install TeamViewer.TeamViewer.Host`n";return}
        '2' {$global:installer += "winget install TeamViewer.TeamViewer`n";return}
        '^*' {"ERROR: Unrecognized Option";TV-Menu}
    }
}


function PDF-Menu 
{
    param(
        [string]$Title = 'Select a PDF Reader'
    )
    Write-Host "`n=========================$Title==========================="

    Write-Host "1: Adobe Acrobat"
    Write-Host "2: Nitro Pro"
    Write-Host "3: Foxit PDF"
    Write-Host "q: Quit"


    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection)
    {
        '1' {$global:installer += "winget install Adobe.Acrobat.Reader.64-bit`n";return} 
        '2' {'You selected Nitro Reader';return} 
        '3' {$global:installer += "winget install Foxit.FoxitReader`n";return}
        'q' {exit}
        '^*' {"`nERROR: Unrecognized Option`n"; PDF-Menu}
    }
}


function Programs-Menu
{
    param(
        
        $programsAvailable = @('1', '2', '3', '4', '5', '6', '7','d')
    )

#    switch($programsAvailable){
#
#    }

    switch -Regex ($programsAvailable){
        '1' {Write-Host "`n1: Thunderbird"}
        '2' {Write-Host "2: LibreOffice"}
        '3' {Write-Host "3: GIMP"}
        '4' {Write-Host "4: ImageGlass"}
        '5' {Write-Host "5: VLC Media Player"}
        '6' {Write-Host "6: Gnucash"}
        '7' {Write-Host "7: Google Earth Pro"}  
        'd' {Write-Host "D: Done"}
    }

    $selection = Read-Host "`nEnter your selection"
    
#    if(-Not ($programsAvailable.Contains($selection) -AND (-Not ($selection -eq 'd')))){
    if(-Not ($programsAvailable.Contains($selection))){
        
        if(($selection -gt 0) -or ($selection -lt 8))
        {
            "ERROR: Option has already been selected."
            Programs-Menu $programsAvailable
        }else{
            Write-Output "ERROR: Unrecognized Option"
            Programs-Menu $programsAvailable
        }

    }else{

        switch -Regex ($selection)
        {
            '1' {$global:installer += "winget install Mozilla.Thunderbird`n";Programs-Menu ($programsAvailable -ne '1');return}
            '2' {$global:installer += "winget install TheDocumentFoundation.LibreOffice`n";Programs-Menu ($programsAvailable -ne '2');return}
            '3' {$global:installer += "winget install GIMP.GIMP`n";Programs-Menu ($programsAvailable -ne '3');return}
            '4' {$global:installer += "winget install DuongDieuPhap.ImageGlass`n";Programs-Menu ($programsAvailable -ne '4');return}
            '5' {$global:installer += "winget install VideoLAN.VLC`n";Programs-Menu ($programsAvailable -ne '5');return}
            '6' {$global:installer += "winget install GnuCash.GnuCash`n";Programs-Menu ($programsAvailable -ne '6');return}
            '7' {$global:installer += "winget install Google.EarthPro`n";Programs-Menu ($programsAvailable -ne '7');return}
            'd' {return}
            '^*' {"ERROR: Unrecognized Option -sw"; Programs-Menu $programsAvailable}
            

        }
    }





}

function Update-Windows
{
    $global:installer += "`nInstall-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force`n"
    $global:installer += "Install-Module PSWindowsUpdate -Force`n"

    $global:installer += "Get-WindowsUpdate -AcceptAll -Install -AutoReboot`n"

}

NetworkTest

Change-Power-Settings

#Menu Logic
Rename-Menu
User-Menu

InstallWinget

Install-TV

GP-Menu
PDF-Menu

Programs-Menu

Invoke-Expression $global:path + "\decrapifier.ps1"

Update-Windows

Set-Content -Path .\installer.ps1 -Value $global:installer
Invoke-Expression -Command $global:installer

#uninstall winget
#winget uninstall Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
