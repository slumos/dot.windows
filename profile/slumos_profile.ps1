$syncdir = "$HOME\ODfB\OneDrive - Microsoft"
$mydir = "$syncdir\My"
$psdir = "$my\PowerShell"
$profdir = "$my\Profile"
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

# posh-git: powershell git prompt
#Import-Module "$ps/posh-git/posh-git"
#Enable-Gitcolors
#
#function prompt {
#  $last_exit_code_saved = $LASTEXITCODE
#  $prompt_string = "$((get-date).toString('T')) $(get-location) $last_exit_code_saved"
#  $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
#  Write-Host($prompt_string) -nonewline
#  Write-VcsStatus
#
#  return "> "
#}

function prompt {
  $last_exit_code_saved = $LASTEXITCODE
  $prompt_string = "$((get-date).toString('T')) $(get-location) $last_exit_code_saved"
  return "$prompt_string>"
}

Import-Module Pscx
#. (Join-Path "$psdir" pscx.overrides.ps1)

if ($host.name -eq 'ConsoleHost') {
  Import-Module PSReadline
  Set-PSReadlineOption `
    -EditMode emacs `
    -MaximumHistoryCount 100000 `
    -HistoryNoDuplicates true `
    -HistorySavePath "$profiledir\powershell_history" `
}

# function df ( $Path ) {
#   if ( !$Path ) { $Path = (Get-Location -PSProvider FileSystem).ProviderPath }
#   $Drive = (Get-Item $Path).Root -replace "\\"
#   $Output = Get-WmiObject -Query "select freespace from win32_logicaldisk where deviceid = `'$drive`'"
#   Write-Output "$($Output.FreeSpace / 1mb) MB"
# }

#function save-history {
#  get-history -count (32KB-1) |
#    group CommandLine |
#    foreach {$_.Group[0]} |
#    export-clixml $history_path
#}

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

#Register-EngineEvent PowerShell.Exiting { save-history } -SupportEvent

#if (test-path $history_path) {
#  import-clixml $history_path | add-history
#}

# Adds CommandLine property to ps output
Update-TypeData "$ps\System.Diagnostics.Process.ps1xml"
