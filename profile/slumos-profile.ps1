$emacsdir = "$env:APPDATA\.emacs.d"
$syncdir = "$HOME\Sync"
$odbdir = "$syncdir\OneDrive - Microsoft"
$oddir = "$syncdir\OneDrive"
$wfdir = "C:\WF"
$atdir = "C:\AT"
$mydir = "$wfdir\My"
$psdir = "$my\PowerShell"
$profdir = (Split-Path $profile)
$windir = (Split-Path $profdir)
$projdir = "$mydir\Projects"
$startmenudir = [Environment]::GetFolderPath('StartMenu')
$startupdir = "$startmenudir\Programs\Startup"
$workdir = "$mydir\Work"

$anexp = "$env:AEEnlistment"
$expman = "$anexp\private\ExpMan"
$foray = "$anexp\private\Foray"
$bct = "$expman\bct"
$bct = "$anexp\private\bct"
$cosb = "$atdir\cosmos-bridge"
$cosbc = "$atdir\cosmos_bridge_client"
$sqlb = "$atdir\sqlbridgeclient-ruby"

$foraydebug = "$anexp\target\distrib\debug\amd64\DataMining\Experimentation\Foray"

$omnisharpPath = "C:\WF\My\Projects\OmniSharp-Roslyn\src\OmniSharp\bin\Release\net46"

$env:PSModulePath = "$mydir\PowerShell\Modules;${env:PSModulePath}"

if (Test-Path alias:curl) {
  del alias:curl
}

function addpath($dir) {
  $path = $env:path.split(';')

  if (test-path $dir) {
    $path = @($dir) + $path
  }

  # Stable, case-insensitive unique
  $seen = @{}
  $new_path = @()
  foreach ($d in $path) {
    if (!$seen[$d]) {
        $new_path = $new_path + ($d)
        $seen[$d]++
    }
  }
  
  $env:path = [string]::join(';', $new_path)
}

addpath "$mydir\bin"

Import-Module Pscx -arg "$profdir\Pscx.UserPreferences.ps1"

if ($host.name -eq 'ConsoleHost') {
  Import-Module PSReadline
  Set-PSReadlineOption `
    -EditMode emacs `
    -MaximumHistoryCount 100000 `
    -HistoryNoDuplicates `
    -HistorySavePath "$profdir\powershell_history"
}

function df ( $Path ) {
  if ( !$Path ) { $Path = (Get-Location -PSProvider FileSystem).ProviderPath }
  $Drive = (Get-Item $Path).Root -replace "\\"
  $Output = Get-WmiObject -Query "select freespace from win32_logicaldisk where deviceid = `'$drive`'"
  format-byte $Output.FreeSpace
}

function mem {
  Get-Counter -ComputerName localhost '\Memory\Available MBytes' | Format-Byte
}

function which($command) {
  get-command $command -all | select path
}

function ec {
  emacsclient -n $args
}

function ts {
  get-date -format yyyyMMddTHHmmss
}

function be {
  ruby.exe -S bundle exec $args
}

# Adds CommandLine property to ps output
Update-TypeData "$profdir\System.Diagnostics.Process.ps1xml"

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

. $profdir\slumos-prompt.ps1
. $profdir\slumos-util.ps1
