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

#Append strings to the end of the installer. At the end run installer with Invoke-Expression
$installer = ""

#Use flag --accept-source-agreements for first winget cmd

#Output selections to powershell script, then execute script

#Menus
Clear-Host
function GP-Menu{
    param(
        [string]$Title = 'Select GP'
    )

    Write-Host "=========================$Title==========================="

    Write-Host "1: Apply Guardian Group Policy"
    Write-Host "2: No Group Policy"
    Write-Host "q: Quit"
    

    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection)
    {
        '1' {"`nApplying Group Policy`n"; Break} 
        '2' {"`nSkipping Group Policy`n"; Break}
        'q' {return} 
        '^*' {"`nERROR: Unrecognized Option`n"; GP-Menu}
    }
}





function PDF-Menu 
{
    param(
        [string]$Title = 'Select a PDF Reader'
    )
    Write-Host "`n=========================$Title==========================="

    Write-Host "1: Adobe Acrobat"
    Write-Host "2: Nitro"
    Write-Host "q: Quit"


    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection)
    {
        '1' {$installer += "winget install Adobe.Acrobat.Reader.64-bit;"} 
        '2' {'You selected Nitro Reader'} 
        'q' {return}
        '^*' {"`nERROR: Unrecognized Option`n"; PDF-Menu}
    }
}


#Allow people to select multiple options. Restart with the selected programs missing from selection.
function Other-Programs
{
    $programsAvailable = @(1, 2, 3, 4)

    switch($programsAvailable){

    }
    Write-Host "1: LibreOffice"
    Write-Host "2: Gnucash"
    Write-Host "3: GIMP"
    Write-Host "4: Google Earth Pro"
    Write-Host "ImageGass"

}



#Menu Logic


GP-Menu
PDF-Menu




#uninstall winget
#winget uninstall Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
