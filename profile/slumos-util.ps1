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
