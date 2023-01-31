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

Clear-Host

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
            'y'{return}
            'n'{Break}
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

function Rename-Menu{
    $newname = Read-Host "Enter a name for this device"

    Rename-Device -NewName $newname 
}


function Rename-Device
{
    param(
        [string]$NewName
    )

    $confirm = Read-Host "`nThe device name will be:" $newname "`nIs that correct?`nType Y(yes) or N(no)"

    switch -Regex ($confirm){
        'y'{ "Change Name"; return}
        'n'{Rename-Menu}
        '^*'{'ERROR: Unrecognized Option';Rename-Device}
    }
}


function GP-Menu
{
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
        '1' {"`nApplying Group Policy`n"; return} 
        '2' {"`nSkipping Group Policy`n"; return}
        'q' {return} 
        '^*' {"`nERROR: Unrecognized Option`n"; GP-Menu}
    }
}


function TV-Menu
{
    Write-Host "1: Teamviewer Host"
    Write-Host "2: Teamviewer"

    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection){
        '1' {$installer += "winget install TeamViewer.TeamViewer.Host;";return}
        '2' {$installer += "winget install TeamViewer.TeamViewer;";return}
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
    Wirte-Host "3: Foxit PDF"
    Write-Host "q: Quit"


    $selection = Read-Host "Enter your selection"

    switch -Regex ($selection)
    {
        '1' {$installer += "winget install Adobe.Acrobat.Reader.64-bit;";return} 
        '2' {'You selected Nitro Reader';return} 
        '3' {$installer += "winget install Foxit.FoxitReader"}
        'q' {Break}
        '^*' {"`nERROR: Unrecognized Option`n"; PDF-Menu}
    }
}


function Other-Programs
{
    param(
        
        $programsAvailable = @('1', '2', '3', '4', '5', '6', '7')
    )

#    switch($programsAvailable){
#
#    }
    Write-Output $programsAvailable
    switch -Regex ($programsAvailable){
        '1' {Write-Host "1: Thunderbird"}
        '2' {Write-Host "2: LibreOffice"}
        '3' {Write-Host "3: GIMP"}
        '4' {Write-Host "4: ImageGlass"}
        '5' {Write-Host "5: VLC Media Player"}
        '6' {Write-Host "6: Gnucash"}
        '7' {Write-Host "7: Google Earth Pro"}  
        'd' {Write-Host "D: Done"}
    }

    $selection = Read-Host "Enter your selection"
    
#    if(-Not ($programsAvailable.Contains($selection) -AND (-Not ($selection -eq 'd')))){
    if(-Not ($programsAvailable.Contains($selection) -AND (-Not ($selection -eq 'd')))){
        
        if(($selection -gt 0) -or ($selection -lt 8))
        {
            "ERROR: Option has already been selected."
            Other-Programs $programsAvailable
        }else{
            Write-Output "ERROR: Unrecognized Option"
            Other-Programs $programsAvailable
        }

    }else{

        switch -Regex ($selection)
        {
            '1' {$installer += "winget install Mozilla.Thunderbird`n";Other-Programs ($programsAvailable -ne '1')}
            '2' {$installer += "winget install TheDocumentFoundation.LibreOffice`n";Other-Programs ($programsAvailable -ne '2')}
            '3' {$installer += "winget install GIMP.GIMP`n";Other-Programs ($programsAvailable -ne '3')}
            '4' {$installer += "winget install DuongDieuPhap.ImageGlass`n";Other-Programs ($programsAvailable -ne '4')}
            '5' {$installer += "winget install VideoLAN.VLC`n";Other-Programs ($programsAvailable -ne '5')}
            '6' {$installer += "winget install GnuCash.GnuCash`n";Other-Programs ($programsAvailable -ne '6')}
            '7' {$installer += "winget install Google.EarthPro`n";Other-Programs ($programsAvailable -ne '7')}
            'd' {return}
            '^*' {"ERROR: Unrecognized Option"; Other-Programs $programsAvailable}
            

        }
    }





}

NetworkTest

#Menu Logic
Rename-Menu
TV-Menu

GP-Menu
PDF-Menu




#uninstall winget
#winget uninstall Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
