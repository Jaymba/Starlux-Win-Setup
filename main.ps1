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

#TO-DO check if winget is installed before installing and delete msixbundle after installation.
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "C:\Users\Admin\Downloads\WinGet.msixbundle"
Add-AppxPackage "C:\Users\Admin\Downloads\WinGet.msixbundle"

#Use flag --accept-source-agreements for first winget cmd


#uninstall winget
winget uninstall Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
