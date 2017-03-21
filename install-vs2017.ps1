# You are expected to edit this section with your preferences
#$installPath = "$env:ProgramFiles\VS2017"
$installPath = "C:\VS\2017"

$vsUrl = "https://aka.ms/vs_enterprise.exe"
$vsPath = "$HOME\Downloads\vs_enterprise.exe"

$installIds = @(
  "Microsoft.VisualStudio.Workload.Azure",
  "Microsoft.VisualStudio.Workload.Data",
  "Microsoft.VisualStudio.Workload.NetCoreTools",
  "Microsoft.VisualStudio.Workload.NetWeb",
  "Microsoft.VisualStudio.Component.LinqToSql",
  "Microsoft.VisualStudio.Component.TestTools.Core",
  "Microsoft.VisualStudio.Component.TestTools.FeedbackClient",
  "Microsoft.VisualStudio.Component.TestTools.MicrosoftTestManager",
  "Microsoft.VisualStudio.Component.TestTools.WebLoadTest",
  "Microsoft.VisualStudio.Component.TypeScript.2.0"
)

if (Test-Path $installPath) {
  Write-Warning "$installPath exists, cowardly refusing to continue"
  exit -1
}

# TODO Check .NET version 
# Meh, I can't find a reliable method, maybe because my personal setup
# is hosed.

Write-Output "Installing to $installPath"
mkdir $installPath | Out-Null
pushd $installPath

$vsOpts = @(
  "--installPath $installPath",
  "--includeRecommended",
  "--norestart",
  "--wait",
  "--quiet"
) + ($installIds | % {'--add ' + $_})

$vsCmd = "$vsPath " + ($vsOpts -join ' ')

if (!(Test-Path $vsPath)) {
  try {
    Write-Output "Fetching installer from $vsUrl"
    Invoke-WebRequest -OutFile $HOME\Downloads\vs_enterprise.exe https://aka.ms/vs/15/release/vs_enterprise.exe -Verbose
  }
  catch {
    Write-Error "failed."
    exit -1
  }
}

Write-Output "About to run VS installer like:`
  $vsCmd"
Write-Warning "Note: This will fail if you don't have .NET 4.5+..."

$message = "That what you want?"
$choices = [System.Management.Automation.Host.ChoiceDescription[]](
  (new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Yes - Continue"),
  (new-Object System.Management.Automation.Host.ChoiceDescription "&No","No - Exit")
)
$answer = $host.ui.PromptForChoice($caption,$message,$choices,0)
if ($answer -ne 0) {
  exit 0
}

try {
  Start-Process -FilePath "$vsPath" -ArgumentList ($vsOpts -join ' ') -Wait
}
catch {
  Write-Error "VS setup failed :-("
  exit -1
}

if ($? -eq 0) {
  Write-Output "VS setup appears to have succeeded, what!"
  Write-Warning "You probably have to restart now..."
}
else {
  Write-Error "VS setup appears to have failed. :-( Not cleaning up so maybe you can debug."
  exit -1
}
