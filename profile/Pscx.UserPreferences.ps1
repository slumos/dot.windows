@{
  TextEditor = 'emacsclient.exe'  
  PageHelpUsingLess = $true  
  FileSizeInUnits = $true
  
  ModulesToImport = @{
    CD                = $true
    DirectoryServices = $true
    FileSystem        = $true
    GetHelp           = $true
    Net               = $true
    Utility           = $true
    Vhd               = $true
    Wmi               = $true
  }    
}
