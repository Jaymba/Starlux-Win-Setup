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

Clear-Host

Set-TimeZone "Eastern Standard Time"

if((Get-Service -Name W32Time).Status -eq "Stopped"){
    net start w32time
}

if(-Not (Get-Command pwsh -errorAction SilentlyContinue)){ #run PWSH if already installed, if not, run Windows Powershell
        $global:PScommand = "powershell"
    }
    else
    {
        $global:PScommand = "pwsh"
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
        -FilePath $global:PScommand `
        -ArgumentList (
            #flatten to single array
	    '-ExecutionPolicy Bypass',
            '-File', $MyInvocation.MyCommand.Source, $args `
            | %{ $_ }
        ) `
        -Verb RunAs
    exit
}

$global:installer = ""
$global:username = ""
$global:path = Split-Path ($MyInvocation.MyCommand.Path) -Parent 
$global:QCADversion = "3.28.2"
$global:QCADDLLs = 'qcaddwg.dll','qcadpdf.dll','qcadpolygon.dll','qcadproj.dll','qcadproscripts.dll','qcadshp.dll','qcadtrace.dll','qcadtriangulation.dll','qcadspatialindexpro.dll'
function RunPWSH($MyInvocation, $args){

    if($PSVersionTable.PSEdition -eq "Desktop"){

     Start-Process `
       -FilePath 'pwsh' `
       -ArgumentList (
           #flatten to single array
	   '-ExecutionPolicy Bypass',
           '-File', $MyInvocation.MyCommand.Source, $args `
           | %{ $_ }
       ) `
       -Verb RunAs
     exit
  }
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
        Write-Output "SSD DETECTED"
        return
    }
}

function Change-Power-Settings
{
    param(
        [switch]$NoStandby
    )

    powercfg /Change monitor-timeout-ac 10

    if($NoStandby){
	powercfg /Change standby-timeout-ac 0
    }
    else{
        powercfg /Change standby-timeout-ac 120
    }

}


function InstallWinget{

   
    if(-Not (Get-Command winget -errorAction SilentlyContinue) -or -Not ((winget -v).TrimStart('v') -ge '1.3')){ #if winget is not found or not new enough version

        if($PSVersionTable.PSEdition -eq "Core"){
	     Import-Module Appx -UseWindowsPowerShell #just in case winget install tries to run on PS Core
        }

	$ProgressPreference = 'SilentlyContinue' # should speed up downloads on Windows Powershell

	if((Get-AppxPackage -name 'Microsoft.VCLibs.140.00.UWPDesktop').Version.TrimStart('14.0.') -lt 30704){ #check if less than minimum version
	     Write-Host 'Installing VCLibs'
	     Add-AppxPackage 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
	}

	if((Get-AppxPackage -name 'Microsoft.UI.Xaml.2.7*') -eq $null){ #check if any version of Microsoft.UI.Xaml.2.7 exists
	     Write-Host 'Installing Microsoft.UI.Xaml'
	     Invoke-WebRequest -Uri 'https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3' -OutFile ($global:path + '\Microsoft.UI.Xaml.2.7.3.zip')
	     Expand-Archive -path ($global:path + '\Microsoft.UI.Xaml.2.7.3.zip') -DestinationPath ($global:path + '\Microsoft.UI.Xaml.2.7.3')
	     Add-AppxPackage ($global:path + '\Microsoft.UI.Xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx')
             Remove-Item ($global:path + '\Microsoft.UI.Xaml.2.7.3.zip')
             Remove-Item -Recurse ($global:path + '\Microsoft.UI.Xaml.2.7.3')
	}

	Write-Host 'Installing WinGet'
        Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile ($global:path + '\WinGet.msixbundle')
        Add-AppxPackage ($global:path + '\WinGet.msixbundle')
        Remove-Item ($global:path + '\Winget.msixbundle')
    }

    #Random winget cmd used to accept agreements
    winget search --accept-source-agreements Acc > $null
}

function InstallPWSH
{
    if(-Not (Get-Command pwsh -errorAction SilentlyContinue)){
        winget install --id 9MZ1SNWT0N5D --source msstore --accept-source-agreements --accept-package-agreements
    }
}

#Append strings to the end of the installer. At the end run installer with Invoke-Expression
$global:installer = ""

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
    $global:username = Read-Host "Enter a name for the User"

    Create-User -NewName $global:username 
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
        'y'{ $global:installer += "`n" + 'if($PSVersionTable.PSEdition -eq "Core"){Import-Module Microsoft.Powershell.LocalAccounts -UseWindowsPowerShell}'; $global:installer += "`nNew-LocalUser -Name " + $NewName + " -NoPassword`n";break}
        'n'{User-Menu;return}
        '^*'{'ERROR: Unrecognized Option';Create-User}
    }
    Set-Admin $NewName
    Set-PasswordNeverExpires $NewName
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

function Set-PasswordNeverExpires
{
    param(
	[string] $Name
    )
    $global:installer += "Set-LocalUser -PasswordNeverExpires 1 -Name $Name" + "`n" #Do without asking
    #$passwordsetting = Read-Host "`nShould the User's password expire?`nType: Y(Yes) or N(No)"
#
#    switch -Regex ($passwordsetting){
#	'y' {return}
#	'n' { $global:installer += "Set-LocalUser -PasswordNeverExpires 1 -Name " + $Name + "`n";return}
#	'^*'{"Error: Unrecognized Option."; Set-PasswordNeverExpires $name}
#    }
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
    $global:installer += "`nCopy-Item '$global:path\GP\*' -Destination 'C:\Windows\System32' -Force -Recurse`n`n"
}

function Download-Manual
{
    param(
        [string]$Link,
        [string]$Filename
    )

    if(!(Test-path "C:\Users\Public\Desktop\Manuals and Instructions"))
    {
        New-Item -Path "C:\Users\Public\Desktop\Manuals and Instructions" -ItemType Directory
    }

    Invoke-WebRequest -Uri $Link -OutFile "C:\Users\Public\Desktop\Manuals and Instructions\$Filename"
}

function Install-QCAD
{
    $global:installer += "Invoke-WebRequest -Uri https://www.qcad.org/archives/qcad/qcad-" + $global:QCADversion + "-trial-win64-installer.msi -OutFile " + $global:path + "\qcad-" + $global:QCADversion + "trial-win64-installer.msi`n"
    $global:installer += "Start-Process msiexec.exe -Wait -ArgumentList '/I " + $global:path + "\qcad-" + $global:QCADversion + "trial-win64-installer.msi" + " /quiet'`n"
    
    $global:installer += 'Remove-Item ($global:path + "\qcad-" + $global:QCADversion + "trial-win64-installer.msi")' + "`n"
    
    $global:installer += 'foreach ($QCADDLL in $global:QCADDLLs)
    {
	if(Test-Path "C:\Program Files\QCAD\plugins\$QCADDLL") {
	   Remove-Item "C:\Program Files\QCAD\plugins\$QCADDLL"
	}
    }' + "`n"

     $global:installer += 'Download-Manual -Link "https://qcad.org/doc/qcad/latest/reference/en/qcad_reference_manual_en.pdf" -Filename "qcad_reference_manual_en.pdf"' + "`n"
#    $global:installer += 'if(!(Test-path "C:\Users\Public\Desktop\Manuals and Instructions"))
#    {
#	New-Item -Path "C:\Users\Public\Desktop\Manuals and Instructions" -ItemType Directory
#    }' + "`n"
#    $global:installer += "Invoke-WebRequest -Uri 'https://qcad.org/qcad/book/qcad_book_preview_en.pdf' -OutFile " + '"C:\Users\Public\Desktop\Manuals and Instructions\' + 'qcad_book_preview_en.pdf"'
}

function Libreoffice-Docs
{
     Download-Manual -Link 'https://documentation.libreoffice.org/assets/Uploads/Documentation/en/CG7.6/CG76-CalcGuide.pdf' -Filename 'CG76-CalcGuide.pdf'
     Download-Manual -Link 'https://documentation.libreoffice.org/assets/Uploads/Documentation/en/DG7.6/DG76-DrawGuide.pdf' -Filename 'DG76-DrawGuide.pdf'
     Download-Manual -Link 'https://documentation.libreoffice.org/assets/Uploads/Documentation/en/IG7.6/IG76-CalcGuide.pdf' -Filename 'IG76-ImpressGuide.pdf'
     Download-Manual -Link 'https://documentation.libreoffice.org/assets/Uploads/Documentation/en/WG7.6/WG76-WriterGuide.pdf' -Filename 'WG76-WriterGuide.pdf'
     Download-Manual -Link 'https://documentation.libreoffice.org/assets/Uploads/Documentation/en/GS7.5/GS75-GettingStarted.pdf' -Filename 'GS75-GettingStarted.pdf'
}

function Install-TV
{
    $global:installer += "winget install TeamViewer.TeamViewer.Host --scope machine`n"

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
    Write-Host "s: Skip"
    Write-Host "q: Quit"


    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection)
    {
        '1' {$global:installer += "winget install Adobe.Acrobat.Reader.64-bit --scope machine`n";return} 
        '2' {$global:installer += "winget install NitroSoftware.NitroPro --scope machine`n";return} 
        '3' {$global:installer += "winget install Foxit.FoxitReader --scope machine`n";return}
        's' {return}
        'q' {exit}
        '^*' {"`nERROR: Unrecognized Option`n"; PDF-Menu}
    }
}


function Programs-Menu
{
    param(
        
        $programsAvailable = @('1', '2', '3', '4', '5', '6', '7', '8', '9','d')
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
        '8' {Write-Host "8: DreamPlan"}
	'9' {Write-Host "9: QCAD Community"}
        'd' {Write-Host "D: Done"}
    }

    $selection = Read-Host "`nEnter your selection"
    
#    if(-Not ($programsAvailable.Contains($selection) -AND (-Not ($selection -eq 'd')))){
    if(-Not ($programsAvailable.Contains($selection.ToLower()))){
        
        if(($selection -gt 0) -or ($selection -lt 9))
        {
            "ERROR: Option has already been selected."
	    $env:selection
            Programs-Menu $programsAvailable

        }else{
            Write-Output "ERROR: Unrecognized Option"
            Programs-Menu $programsAvailable
        }

    }else{

        switch -Regex ($selection)
        {
            '1' {$global:installer += "winget install Mozilla.Thunderbird`n";Programs-Menu ($programsAvailable -ne '1');return}
            '2' {$global:installer += "winget install TheDocumentFoundation.LibreOffice --scope machine`n" + "Libreoffice-Docs`n";Programs-Menu ($programsAvailable -ne '2');return}
            '3' {$global:installer += "winget install GIMP.GIMP --scope machine`n";Programs-Menu ($programsAvailable -ne '3');return}
            '4' {$global:installer += "winget install DuongDieuPhap.ImageGlass --scope machine`n";Programs-Menu ($programsAvailable -ne '4');return}
            '5' {$global:installer += "winget install VideoLAN.VLC --scope machine`n";Programs-Menu ($programsAvailable -ne '5');return}
            '6' {$global:installer += "winget install GnuCash.GnuCash --scope machine`n" + "Download-Manual -Link 'https://code.gnucash.org/docs/C/gnucash-guide.pdf' -Filename 'gnucash-guide.pdf'`n";Programs-Menu ($programsAvailable -ne '6');return}
            '7' {$global:installer += "winget install Google.EarthPro --scope machine`n";Programs-Menu ($programsAvailable -ne '7');return}
            #DreamPlan
            '8' {$global:installer += "winget install 9NXSX2KDNKMT --scope machine`n";Programs-Menu ($programsAvailable -ne '8');return}
	    '9' {Install-QCAD;Programs-Menu ($programsAvailable -ne '9');return}
            'd' {return}
            '^*' {"ERROR: Unrecognized Option -sw"; Programs-Menu $programsAvailable}
            

        }
    }





}

function Import-StartMenuOptions
{
   $global:installer += "`nNew-Item -ItemType Directory -Path C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState -ErrorAction SilentlyContinue`n"
   $global:installer += ("Copy-Item -Path " + $global:path + "\dependencies\start2.bin -Destination C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState`n")
   $global:installer += ("Copy-Item -Force -Path " + $global:path + "\dependencies\start2.bin -Destination " + $env:UserProfile + "\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState`n")
   $global:installer += "Stop-Process -Name StartMenuExperienceHost -Force`n"
}

function Reset-UserExecutionPolicy
{
    Set-ExecutionPolicy -Scope CurrentUser Undefined
    Set-ExecutionPolicy -Scope LocalMachine Undefined
}

function Update-Windows
{
    $global:installer += "`nInstall-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force`n"
    $global:installer += "Install-Module PSWindowsUpdate -Force`n"

    $global:installer += "Get-WindowsUpdate -AcceptAll -Install`n" #-AutoReboot
    $global:installer += "Change-Power-Settings`n"
    $global:installer += "Restart-Computer -Force`n"

}

function RunInit
{
    param(
	[bool] $PostInit,
	[string]$Title = 'Running initial setup'
    )

    if($PostInit -eq 0)
    {
	Write-Host 'Init will now run. Next run of this script will automatically run Post-Init. If you do not want this behavior, delete the "InitialSetupDone" file'
	Start-Sleep 5
	[void](New-Item ($global:path + "\InitialSetupDone"))
    }
    else
    {
	$global:installer = ""
    }

    Install-TV 
    $global:installer += ("powershell " + $global:path + "\dependencies\decrapify.ps1`n") 
    $global:installer += ("powershell " + $global:path + "\dependencies\CleanupApps.ps1`n")
    Import-StartMenuOptions

    Update-Windows 

    InstallWinget
    InstallPWSH
    Set-Content -Path ($global:path + "\1-init-installer.ps1") -Value $global:installer 
    Invoke-Expression -Command $global:installer 
   

}

function RunPostInit
{
    param(
#	[bool] $WinUpdate,
        [string]$Title = 'Running post-init setup'
    )
    #Menu Logic

    Rename-Menu 
    User-Menu 


    GP-Menu 
    PDF-Menu 

    Programs-Menu 

#    if($WinUpdate -eq 1)
#    {
#	Update-Windows 
#    }

    InstallWinget
    Set-Content -Path ($global:path + "\2-postinit-installer.ps1") -Value $global:installer 
    Invoke-Expression -Command $global:installer 

}

function Script-Menu
{
    param(
        [string]$Title = 'Select the type of setup you would like to run'
    )

    Write-Host "`n=========================$Title==========================="

    Write-Host "1: Initial Install"
    Write-Host "2: Full Setup"
    Write-Host "q: Quit"


    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection)
    {
        '1' {RunInit 0; return} #run init with special text
        '2' {RunPostInit; RunInit 1; Reset-UserExecutionPolicy; return} #run Post Init and Init without special text
        'q' {exit}
        '^*' {"`nERROR: Unrecognized Option`n"; Script-Menu}
    }
}

NetworkTest 
CheckDrive 
Change-Power-Settings -NoStandby

#InstallWinget 
#InstallPWSH 
#RunPWSH $MyInvocation $args 
# uncomment above lines to install and run PWSH before script is used

if(Test-Path ($global:path + "\InitialSetupDone")) #run Script unless init file is found
{
    RunPostInit
    Reset-UserExecutionPolicy
    Change-Power-Settings
}
else
{
    Script-Menu
}

#$global:installer += @"
##Enter-PSSession -ComputerName localhost -Credential $global:username`n
##Invoke-Expression $global:path + '\decrapifier.ps1'`n
##Exit-PSSession
#"@



#uninstall winget
#winget uninstall Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
