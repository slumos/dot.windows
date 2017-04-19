$Boxstarter.RebootOk=$true
$Boxstarter.AutoLogin=$true

# Block narrator because omfg
Write-BoxstarterMessage "Accessibility settings"
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" -Type Folder | Out-Null
}
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" "Debugger" "%1"

# Turn off accessibility hotkeys
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

# Why is this hard? WE LOG IN WITH PINs!!
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value 2

Write-BoxstarterMessage "Installing Chocolatey"
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
Install-PackageProvider -Force Chocolatey
Import-PackageProvider Chocolatey

# This is one of those lovable things about PoSH
$PSDefaultParameterValues["Install-Package:Force"] = $true
$PSDefaultParameterValues["Install-Package:Verbose"] = $true

# Windows options
Write-BoxstarterMessage "Updating Windows (it's Tuesday somewhere, right?)"
#Install-WindowsUpdate -acceptEula -SuppressReboots

Write-BoxstarterMessage "Explorer options"
Set-WindowsExplorerOptions `
  -EnableShowHiddenFilesFoldersDrives `
  -EnableShowProtectedOSFiles `
  -EnableShowFileExtensions `
  -EnableShowFullPathInTitleBar `
  -EnableShowFrequentFoldersInQuickAccess

Set-TaskbarOptions -Size Small -Lock -Dock Bottom -Combine Always

Disable-GameBarTips
Disable-BingSearch

# Don't remember where I saw this, but there is no sure thing as Set-UICulture :-(
# $settings = (Get-UICulture)
# $settings.DateTimeFormat.LongTimePattern = 'H:mm:ss'
# $settings.DateTimeFormat.ShortTimePattern = 'H:mm'
# Set-UICulture $settings

# Packages that are reasonable or some awesomely
# chocolatey person made them so
Write-BoxstarterMessage "Packages packages packages"
cinst autohotkey
cinst emacs64
cinst pt
cinst slack

Install-Package conemu
Install-Package emacs64
Install-Package f.lux
Install-Package vim -source chocolatey
Install-Package git
Install-Package PSReadline
Install-Package Pscx -source PSGallery
Install-Package posh-git -source chocolatey
Install-Package posh-vs
Install-Package nodejs
Install-Package npm
Install-Package GoogleChrome
Install-Package skyfonts
Install-Package Git-Credential-Manager-for-Windows
Install-Package xmlstarlet

Install-Package win32-openssh

# Packages that require licensing
Install-Package Linqpad5

# Visual Studio, the bear of unhelpful install grrr
#if (!(test-path "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\")) {
#  Write-BoxstarterMessage "Start Visual Studio 2015 install."
#  Start-Process -Wait `
#    -FilePath '\\products\public\PRODUCTS\Developers\Visual Studio 2015\Enterprise 2015.3\vs_enterprise.exe' `
#    -ArgumentList "/passive /norestart /installselectableitems CommonTools_Group;Windows10_Group;NativeLanguageSupport_Group;ProgrammingLanguages_Group;WindowsPlatformDevelopment_GroupV1;Node.js;GitForWindows;GitHubVS"

  # The Azure .NET SDK will not see VS2015 until after a reboot. BECAUSE
  # WHY WOULD IT??
  # if (Test-PendingReboot) { Invoke-Reboot }
#}
#else {
#  Write-BoxstarterMessage "Visual Studio 2015 already installed."
#}

# Then we install the SDK... which VS2015 will not see until after
# another reboot. For real? Why are we so weak?
cinst webpi
#C:\Program` Files\Microsoft\Web` Platform` Installer\WebpiCmd-x64.exe /Install /Products:Vs2015AzurePack.2.8 /SuppressReboot /AcceptEula /IISExpress /Verbose

# if (Test-PendingReboot) { Invoke-Reboot }

