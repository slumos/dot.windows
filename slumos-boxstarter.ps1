Set-ExecutionPolicy Unrestricted -Force

# Block narrator because omfg
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" -Type Folder | Out-Null
}
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" "Debugger" "%1"

# Turn off accessibility hotkeys
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

Install-PackageProvider -Force Chocolatey
Import-PackageProvider Chocolatey

# This is one of those lovable things about PoSH
$PSDefaultParameterValues["Install-Package:Force"] = $true
$PSDefaultParameterValues["Install-Package:Verbose"] = $true

# Windows options
Install-WindowsUpdate -acceptEula -SuppressReboots

Set-WindowsExplorerOptions `
  -EnableShowHiddenFilesFoldersDrives `
  -EnableShowProtectedOSFiles `
  -EnableShowFileExtensions `
  -EnableShowFullPathInTitleBar `
  -EnableShowFrequentFoldersInQuickAccess

Set-TaskbarOptions -Size Small -Lock -Dock Bottom -Combine Always

Disable-GameBarTips
Disable-BingSearch

# Can't run IE without UAC :-\
#Disable-UAC
Disable-MicrosoftUpdate

$settings = (Get-UICulture)
$settings.DateTimeFormat.LongTimePattern = 'H:mm:ss'
$settings.DateTimeFormat.ShortTimePattern = 'H:mm'
Set-UICulture $settings


# Packages that are reasonable or some awesomely
# chocolatey person made them so
Install-Package conemu
Install-Package emacs64
Install-Package vim -source chocolatey
Install-Package git
Install-Package pt
Install-Package PSReadline
Install-Package Pscx -source PSGallery
Install-Package poshgit -source PSGallery
Install-Package posh-vs
Install-Package nodejs
Install-Package npm
Install-Package GoogleChrome
Install-Package skyfonts
Install-Package Git-Credential-Manager-for-Windows
Install-Package wox

Install-Package win32-openssh

# Packages that require licensing
# LINQPad: VAMH3-2U5P2 - How can this be automated?
Install-Package Linqpad5

# Visual Studio, the bear of unhelpful install grrr
Start-Process -Wait `
  -FilePath "\\products\public\PRODUCTS\Developers\Visual Studio 2015\Enterprise 2015.2\vs_enterprise.exe" `
  -ArgumentList "/quiet /norestart /installselectableitems ProgrammingLanguages_Group;WindowsPlatformDevelopment_GroupV1;Node.js;GitForWindows;GitHubVS"


# The Azure .NET SDK will not see VS2015 until after a reboot. BECAUSE
# WHY WOULD IT??
Invoke-Reboot

# Then we install the SDK... which VS2015 will not see until after
# another reboot. For real? Why are we so weak?
Install-Package 
webpicmd.exe /Install /Products:Vs2015AzurePack.2.8 /SuppressReboot /AcceptEula /IISExpress /Verbose

# Error		All projects referencing CosmosBridge.csproj must install nuget package Microsoft.Bcl.Build. For more information, see http://go.microsoft.com/fwlink/?LinkID=317569.	AzureDeployLocal	C:\Users\slumos\Source\Repos\cosmos-bridge\lib\packages\Microsoft.Bcl.Build.1.0.21\build\Microsoft.Bcl.Build.targets	243	

# TODO
# 1. CodeFlow


