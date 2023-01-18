

#TO-DO check if winget is installed before installing and delete msixbundle after installation.
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "C:\Users\Admin\Downloads\WinGet.msixbundle"
Add-AppxPackage "C:\Users\Admin\Downloads\WinGet.msixbundle"



#uninstall winget
winget uninstall Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
