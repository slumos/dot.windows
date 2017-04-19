function Replace-EnvPrefix
{
  param(
    [string]$path
  )

  $pathVars = Get-Variable |
    where {is-pathvar $_}  |
    sort @{Expression={$_.Value.Length}} -Descending

  foreach ($var in $pathVars) {
    if ($path.StartsWith($var.Value)) {
      return $path.Replace($var.Value, "`$$($var.Name)")
    }
  }

  return $path
}

function is-pathvar($var)
{
  $ignoredVars = @(
    'path',
    'Error',
    'PWD',
    '$',
    '^'
  )

  if ($var.Name -in $ignoredVars) { return $false }
  try {
    if (Test-Path -EA Ignore $var.Value) { return $true }
  }
  catch {
    return $false
  }
  return $false
}

Import-Module posh-git
function global:prompt {
  $savedLASTEXITCODE = $LASTEXITCODE
  $now = Get-Date
  $time_string = $now.toString("%d") + $now.toString("MMM") + " " + $now.toString("T")
  Write-Host "$time_string $(Replace-EnvPrefix $pwd.ProviderPath)" -nonewline
  Write-VcsStatus
  #Write-Host " $savedLASTEXITCODE" -nonewline
  [Console]::ResetColor()
  if ($env:ConEmuTask -eq '{AnExp}') {
    Write-Host '(AE)' -nonewline
  }
  return "> "
}
