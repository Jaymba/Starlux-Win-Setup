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

function NetworkTest{

    param(
        [bool] $CheckNetwork = 1
    )
    if($CheckNetwork){
        
        if(-Not (Test-Connection -ComputerName 1.1.1.1 -Quiet -ErrorAction SilentlyContinue)){
            "Error: Please check your internet connection"
        }else{
            Break
        }

    }


    Write-Host "`nr: Retry"
    Write-Host "q: Quit"

    $selection = Read-Host "Enter your selection"
    
    switch -Regex ($selection){
        "r"{NetworkTest}
        "q"{return}
        "^*"{"Ivalid Option";NetworkTest -CheckNetwork 0}
    }


}

function CheckDrive{
    
    $disk = Get-PhysicalDisk
    
    if($disk.MediaType -eq "HDD"){
        Write-Output "`nWARNING: HDD DETECTED.`nProceed?"

        $selection = Read-Host "Enter: Y(Yes) or N(No)"
        switch -Regex ($selection){
            'y'{Break}
            'n'{return}
            '^*'{'Invalid Option';CheckDrive}
            
        }
    }else{
        Break
    }
}

function InstallWinget{

    if(-Not (Get-Command winget -errorAction SilentlyContinue)){
        Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile ".\WinGet.msixbundle"
        Add-AppxPackage ".\WinGet.msixbundle"    
        Remove-Item ".\Winget.msixbundle"
    }

    #Random winget cmd used to accept agreements
    winget search --accept-source-agreements Acc > $null
}

#Append strings to the end of the installer. At the end run installer with Invoke-Expression
$installer = ""

#Menus
Clear-Host

function Rename-Menu{
    $newname = Read-Host "Enter the new name"

    Rename-Device -NewName $newname 
}
function Rename-Device
{
    param(
        [string]$NewName
    )

    $confirm = Read-Host "The new name will be:" $newname "`nIs that correct?`nType Y(yes) or N(no)"

    switch -Regex ($confirm){
        'y'{ "Change Name"; return}
        'n'{Rename-Menu}
        '^*'{'Enter a valid option';Rename-Device}
    }
}


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


function Other-Programs
{
    $programsAvailable = @(1, 2, 3, 4)

#    switch($programsAvailable){
#
#    }
    Write-Host "1: LibreOffice"
    Write-Host "2: Gnucash"
    Write-Host "3: GIMP"
    Write-Host "4: Google Earth Pro"
    Write-Host "ImageGass"

}

NetworkTest

#Menu Logic
Rename-Menu

GP-Menu
PDF-Menu




#uninstall winget
#winget uninstall Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
