
function Replace-EnvPrefix
{
  param(
    [string]$path
  )

  $prefixVar = find-prefixVar((Get-Variable), $path)
  if ($prefixVar) {
    return $path.Replace($prefixVar.Value, '$'+$prefixVar.Name)
  }

  $prefixVar = find-prefixVar((gci env:), $path)
  if ($prefixVar) {
    return $path.Replace($prefixVar.Value, '$'+$prefixVar.Name)
  }
  
  return $path
}

function find-prefixVar($vars, [string]$string)
{
  $pathVars = ($vars | where {is-pathvar $_} |
    sort @{Expression={$_.Value.Length}} -Descending)
  
  foreach ($var in $pathVars) {
#    write-host "'$string' -like '$($var.Value)*'"
    if ($string -like "$($var.Value)*") {
      return $var
    }
  }
  return $false
}

function is-pathvar($var)
{
  if ($var.Name -in 'path', 'Error', 'PWD', '$', '^') { return $false }
  try {
    if (Test-Path -EA Ignore $var.Value) { return $true }
  }
  catch {
    return $false
  }
  return $false
}

Import-Module posh-git
if ($env:ConEmuTask -eq '{AnExp}') {
  $global:GitPromptSettings.EnableWindowTitle = "[AE] "
}
else {
  $global:GitPromptSettings.EnableWindowTitle = ''
}
function global:prompt {
  $savedLASTEXITCODE = $LASTEXITCODE
  $now = Get-Date
  $time_string = $now.toString("%d") + $now.toString("MMM") + " " + $now.toString("T")
  Write-Host "$time_string $(Replace-EnvPrefix $pwd.ProviderPath)" -nonewline
  Write-VcsStatus
  Write-Host " $savedLASTEXITCODE" -nonewline
  [Console]::ResetColor()
  return "> "
}
