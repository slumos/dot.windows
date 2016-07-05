$PhonebookPath = "${env:PROGRAMDATA}\Microsoft\Network\Connections\PBK\rasphone.pbk"
$VpnName = "Microsoft IT VPN"

Start-Process `
  -NoNewWindow `
  -FilePath rasautou.exe `
  -ArgumentList "-o", "-f", "$PhonebookPath", "-e", "`"$VpnName`""
