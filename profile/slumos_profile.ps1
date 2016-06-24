$syncdir = "$HOME\ODfB\OneDrive - Microsoft"
$mydir = "$syncdir\My"
$psdir = "$my\PowerShell"
$profdir = "$env:appdata\dot.windows\profile"
$projdir = "$my\Projects"

$anexp = "C:\AnExp"
$avocado = "$proj\Avocado"

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

Import-Module posh-git
#function global:prompt {
#  $savedLASTEXITCODE = $LASTEXITCODE
#  Write-Host ($pwd.ProviderPath) -nonewline
#  Write-VcsStatus
#  $global:LASTEXITCODE = $savedLASTEXITCODE
#  return "> "
#}

function global:prompt {
  $savedLASTEXITCODE = $LASTEXITCODE
  $now = Get-Date
  $time_string = $now.toString("%d") + $now.toString("MMM") + " " + $now.toString("T")
  Write-Host "$time_string $($pwd.ProviderPath)" -nonewline
  Write-VcsStatus
  Write-Host " $savedLASTEXITCODE" -nonewline
  return "> "
}

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
#Update-TypeData "$ps\System.Diagnostics.Process.ps1xml"
