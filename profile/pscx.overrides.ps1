# Replace the Pscx less with one that works
function less
{
  param([string[]]$Path, [string[]]$LiteralPath)

  if ($host.Name -ne 'ConsoleHost')
  {
    # The rest of this function only works well in PowerShell.exe
    $input
    return
  }

  $OutputEncoding = [System.Console]::OutputEncoding

  $resolvedPaths = $null
  if ($LiteralPath)
  {
    $resolvedPaths = $LiteralPath
  }
  elseif ($Path)
  {
    $resolvedPaths = @()
    # In the non-literal case we may need to resolve a wildcarded path
    foreach ($apath in $Path)
    {
      if (Test-Path $apath)
      {
        $resolvedPaths += @(Resolve-Path $apath | Foreach { $_.Path })
      }
      else
      {
        $resolvedPaths += $apath
      }
    }
  }

  # Tricky to get this just right.
  # Here are three test cases to verify all works as it should:
  # less *.txt      : Should bring up named txt file in less in succession, press q to go to next file
  # man gcm -full   : Should open help topic in less, press q to quit
  # man gcm -online : Should open help topic in web browser but not open less.exe
  if ($resolvedPaths)
  {
    & "c:\railsinstaller\devkit\bin\less.exe" $resolvedPaths
  }
  elseif ($input.MoveNext())
  {
    $input.Reset()
    $input | & "c:\railsinstaller\devkit\bin\less.exe"
  }
}

$env:LESS="-X"
