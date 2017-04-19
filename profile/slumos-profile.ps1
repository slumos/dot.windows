$emacsdir = "$env:APPDATA\.emacs.d"
$syncdir = "$HOME\Sync"
$odbdir = "$syncdir\OneDrive - Microsoft"
$oddir = "$syncdir\OneDrive"
$atdir = "C:\AT"
$mydir = "$odbdir\My"
$psdir = "$my\PowerShell"
$profdir = (Split-Path $profile)
$windir = (Split-Path $profdir)
$projdir = "$mydir\Projects"
$startmenudir = [Environment]::GetFolderPath('StartMenu')
$startupdir = "$startmenudir\Programs\Startup"
$workdir = "$mydir\Work"
$sftdir = "\\dataengsftower2\e$\slumos"

$notesdir = "$oddir\My\Notes\Notes"
$anexp = "$env:AEEnlistment"
$expman = "$anexp\private\ExpMan"
$foray = "$anexp\private\Foray"
$bct = "$expman\bct"
$bct = "$anexp\private\bct"
$cosb = "$atdir\cosmos-bridge"
$cosbc = "$atdir\cosmos_bridge_client"
$sqlb = "$atdir\sqlbridgeclient-ruby"

$foraydebug = "$anexp\target\distrib\debug\amd64\DataMining\Experimentation\Foray"

$omnisharpPath = "$projdir\OmniSharp-x64-net46"

$env:PSModulePath = "$mydir\PowerShell\Modules;${env:PSModulePath}"

if (Test-Path alias:curl) {
  Remove-Item alias:curl
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

function be {
  ruby.exe -S bundle exec $args
}

function ec {
  emacsclient -n $args
}

function df ( $Path ) {
  if ( !$Path ) { $Path = (Get-Location -PSProvider FileSystem).ProviderPath }
  $Drive = (Get-Item $Path).Root -replace "\\"
  $Output = Get-WmiObject -Query "select freespace from win32_logicaldisk where deviceid = `'$drive`'"
  format-byte $Output.FreeSpace
}

function l {
  if ($Args.Length -ne 1 -or ($Args.Length -eq 1 -and (Get-Item $Args[0]).PSIsContainer)) {
    dir $Args
  }
  else {
    less $Args
  }
}

function mem {
  Get-Counter -ComputerName localhost '\Memory\Available MBytes' | Format-Byte
}

function magit {
  $formattedPWD = $pwd.ProviderPath.Replace("\", "/")
  emacsclient -ne "(magit-status-internal `"$formattedPWD`")"
}

function ts {
  get-date -format yyyyMMddTHHmmss
}

function which($command) {
  get-command $command -all | select path
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

