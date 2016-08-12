# https://www.reddit.com/r/PowerShell/comments/21jzf1/du_hsc_from_bash_for_powershell/
Function Get-DU
{   Param (
        $Path = "."
    )
    ForEach ($File in (Get-ChildItem $Path))
    {   If ($File.PSisContainer)
        {   $Size = (Get-ChildItem $File.FullName -Recurse | Measure-Object -Property Length -Sum).Sum
            $Type = "Folder"
        }
        Else
        {   $Size = $File.Length
            $Type = ""
        }
        [PSCustomObject]@{
            Name = $File.Name
            Type = $Type
            Size = $Size | Format-Byte
        }
    }
}

# http://powershell.com/cs/blogs/tips/archive/2015/03/03/finding-process-owner.aspx
filter Get-ProcessOwner
{
  $id = $_.ID
  $info = (Get-WmiObject -Class Win32_Process -Filter "Handle=$id").GetOwner()
  if ($info.ReturnValue -eq 2)
  {
    $owner = '[Access Denied]'
  }
  else
  {
    $owner = '{0}\{1}' -f $info.Domain, $info.User
  }
  $_ | Add-Member -MemberType NoteProperty -Name Owner -Value $owner -PassThru
}