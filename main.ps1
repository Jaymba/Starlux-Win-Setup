#Common Programs  ID
#Adobe Acrobat:   Adobe.Acrobat.Reader.64-bit
#LibreOffice:     TheDocumentFoundation.LibreOffice
#GnuCash:         GnuCash.GnuCash
#Gimp:            GIMP.GIMP
#GoogleEarthPro   Google.EarthPro
#ImageGlass DuongDieuPhap.ImageGlass
#TypingInstructor


#TO-DO
#Run windows update and reboot. Keep script running through reboot
#Add options to disable sound, video, and images.

#TO-DO check if winget is installed before installing and delete msixbundle after installation.

if(-Not (Get-Command winget -errorAction SilentlyContinue)){
    Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile ".\WinGet.msixbundle"
    Add-AppxPackage ".\WinGet.msixbundle"    
}

#Use flag --accept-source-agreements for first winget cmd


#Menus
function PDF-Menu 
{
    param(
        [string]$Title = 'Select a PDF Reader'
    )
    Clear-Host
    Write-Host "=========================$Title==========================="

    Write-Host "1: Adobe Acrobat"
    Write-Host "2: Nitro"
    Write-Host "q: Quit"
}



#Menu Logic
PDF-Menu
$pdfReader = Read-Host "Enter your selection"

switch($pdfReader)
{
    '1'{
        winget install Adobe.Acrobat.Reader.64-bit
    } '2'{
        'You selected Nitro Reader'
    } 'q'{
        return
    }
}



#uninstall winget
#winget uninstall Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
