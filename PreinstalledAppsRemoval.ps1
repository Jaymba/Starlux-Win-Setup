'''#Power Shell commands to remove unwanted Apps without uninstall option Windows 10

Get-AppxPackage Microsoft.YourPhone -AllUsers | Remove-AppxPackage

Get-AppxPackage Microsoft.XboxGamingOverlay -AllUsers | Remove-AppxPackage

#Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage   "CORTANA"
#Get-AppXProvisionedPackage -online | Remove-AppxProvisionedPackage -online
#Get-AppXPackage | Remove-AppxPackage


#To uninstall Windows communications app
get-appxpackage microsoft.windowscommunicationsapps -AllUsers | remove-appxpackage

#To uninstall Windows Video Editor app
get-appxpackage microsoft.windows.photos -AllUsers | remove-appxpackage

#To uninstall Windows Get Help app
get-appxpackage microsoft.gethelp -AllUsers | remove-appxpackage

#To uninstall 3D Builder:
get-appxpackage *3dbuilder* -AllUsers  | remove-appxpackage

#To uninstall Alarms & Clock:
get-appxpackage *alarms* -AllUsers  | remove-appxpackage

#To uninstall App Connector:
get-appxpackage *appconnector* -AllUsers  | remove-appxpackage

#To uninstall App Installer:
#get-appxpackage *appinstaller* -AllUsers  | remove-appxpackage

#To uninstall Calendar and Mail apps together:
get-appxpackage *communicationsapps* -AllUsers  | remove-appxpackage

#To uninstall Calculator:
get-appxpackage *calculator* -AllUsers  | remove-appxpackage

#To uninstall Camera:
get-appxpackage *camera* -AllUsers  | remove-appxpackage

#To uninstall Feedback Hub:
get-appxpackage *feedback* -AllUsers  | remove-appxpackage

#To uninstall Get Office:
get-appxpackage *officehub* -AllUsers  | remove-appxpackage

#To uninstall Get Started or Tips:
get-appxpackage *getstarted* -AllUsers  | remove-appxpackage

#To uninstall Get Skype:
get-appxpackage *skypeapp* -AllUsers  | remove-appxpackage

#To uninstall Groove Music:
get-appxpackage *zunemusic* -AllUsers  | remove-appxpackage

#To uninstall Groove Music and Movies & TV apps together:
get-appxpackage *zune* -AllUsers  | remove-appxpackage

#To uninstall Maps:
#get-appxpackage *maps* -AllUsers  | remove-appxpackage

#To uninstall Messaging and Skype Video apps together:
get-appxpackage *messaging* -AllUsers  | remove-appxpackage

#To uninstall Microsoft Solitaire Collection:
get-appxpackage *solitaire* -AllUsers  | remove-appxpackage

#To uninstall Microsoft Wallet:
get-appxpackage *wallet* -AllUsers  | remove-appxpackage

#To uninstall Microsoft Wi-Fi:
get-appxpackage *connectivitystore* -AllUsers  | remove-appxpackage

#To uninstall Money:
#get-appxpackage *bingfinance* -AllUsers  | remove-appxpackage

#To uninstall Money, News, Sports and Weather apps together:
get-appxpackage *bing* -AllUsers  | remove-appxpackage

#To uninstall Movies & TV:
get-appxpackage *zunevideo* -AllUsers  | remove-appxpackage

#To uninstall News:
#get-appxpackage *bingnews* -AllUsers  | remove-appxpackage

#To uninstall OneNote:
get-appxpackage *onenote* -AllUsers  | remove-appxpackage

#To uninstall Paid Wi-Fi & Cellular:
get-appxpackage *oneconnect* -AllUsers  | remove-appxpackage

To uninstall Paint 3D:
get-appxpackage *mspaint* -AllUsers  | remove-appxpackage

#To uninstall People:
get-appxpackage *people* -AllUsers  | remove-appxpackage

#To uninstall Phone:
#get-appxpackage *commsphone* -AllUsers  | remove-appxpackage

#To uninstall Phone Companion:
#get-appxpackage *windowsphone* -AllUsers  | remove-appxpackage

To uninstall Phone and Phone Companion apps together:
get-appxpackage *phone* -AllUsers  | remove-appxpackage

#To uninstall Photos:
#get-appxpackage *photos* -AllUsers  | remove-appxpackage

#To uninstall Sports:
get-appxpackage *bingsports* -AllUsers  | remove-appxpackage

#To uninstall Sticky Notes:
#get-appxpackage *sticky* -AllUsers  | remove-appxpackage

#To uninstall Sway:
get-appxpackage *sway* -AllUsers  | remove-appxpackage

#To uninstall View 3D:
get-appxpackage *3d* -AllUsers  | remove-appxpackage

#To uninstall Voice Recorder:
get-appxpackage *soundrecorder* -AllUsers  | remove-appxpackage

#To uninstall Weather:
#get-appxpackage *bingweather* -AllUsers  | remove-appxpackage

#To uninstall Windows Holographic:
#get-appxpackage *holographic* -AllUsers  | remove-appxpackage

#To uninstall Windows Store: (Be very careful!)
#get-appxpackage *windowsstore* | remove-appxpackage

#To uninstall Xbox:
get-appxpackage *xbox* -AllUsers  | remove-appxpackage

#To unistall Spotify:
Get-AppxPackage *SpotifyMusic* -AllUsers | Remove-AppxPackage

#To unistall Disney+:
Get-AppxPackage *disney* -AllUsers | Remove-AppxPackage
'''

$AppsList = "Microsoft.MicrosoftOfficeHub", # Get Office
"Microsoft.SkypeApp", # Get Skype
"microsoft.windowscommunicationsapps", # Mail & Calendar
"Microsoft.People", # People
"Microsoft.CommsPhone", # Phone
"Microsoft.WindowsPhone", # Phone Companion
"Microsoft.XboxApp", # Xbox
"Microsoft.Messaging", # Messaging & Skype
"Microsoft.Reader", # Microsoft Reader
"Microsoft.WindowsCamera", # Camera App
"Microsoft.OneConnect", # Microsoft OneConnect
"Microsoft.Office.OneNote", # Microsoft OneNote
#"Microsoft.WindowsStore", # Store App
"Microsoft.XboxGameOverlay", # Microsoft Xbox Game Overlay
#"Microsoft.Windows.Photos", # Photos app
"Microsoft.MSPaint", # Microsoft Paint 
"Microsoft.Windows.ContentDeliveryManager", # Windows Spotlight & Dynamic Content
"Microsoft.WindowsSoundRecorder", # Microsoft Sound Recorder
#"Microsoft.BingWeather", # Bing Weather App
"Microsoft.Advertising.Xaml", # Microsoft Advertisement App
"Microsoft.ZuneMusic", # Music App
#"Microsoft.WindowsCalculator", # Calculator App
#"Microsoft.WindowsAlarms", # Alarms App
"Microsoft.Microsoft3DViewer", # Microsoft 3D Viewer
"Microsoft.ZuneVideo", # Video App
"Microsoft.WindowsFeedbackHub", # Feedback App
#"Microsoft.StorePurchaseApp", # Microsoft Store Purchase
#"Microsoft.MicrosoftStickyNotes", # Microsoft Sticky Notes
"Microsoft.Wallet", # Microsoft Wallet
#"Microsoft.MicrosoftEdge", # Microsoft Edge
"Microsoft.Windows.Cortana", # Cortana App
"Microsoft.MixedReality.Portal" #Mixed Reality App

ForEach ($App in $AppsList)
{
$Packages = Get-AppxPackage | Where-Object {$_.Name -eq $App}
if ($Packages -ne $null)
{
"Removing Appx Package: $App"
foreach ($Package in $Packages) { Remove-AppxPackage -package $Package.PackageFullName }
}
else { "Unable to find package: $App" }

$ProvisionedPackage = Get-AppxProvisionedPackage -online | Where-Object {$_.displayName -eq $App}
if ($ProvisionedPackage -ne $null)
{
"Removing Appx Provisioned Package: $App"
remove-AppxProvisionedPackage -online -packagename $ProvisionedPackage.PackageName
}
else { "Unable to find provisioned package: $App" }
}