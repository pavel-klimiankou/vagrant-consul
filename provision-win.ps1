$consulDir = "C:\Consul"
$consulExePath = "$consulDir\consul.exe"
$consulZipPath = "c:\tmp\consul.zip"
$version = "0.8.1"

if (-not (Test-Path $consulDir))
{
	# Use newest TLS protocol version for HTTPS connections
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Download consul
	Invoke-WebRequest -OutFile $consulZipPath -Uri https://releases.hashicorp.com/consul/$($version)/consul_$($version)_windows_amd64.zip

	# Unzip
	Expand-Archive -Path $consulZipPath -DestinationPath $consulDir

	# Cleanup
	Remove-Item $consulZipPath

	# Create Consul data dir
	New-Item -Type Directory -Path "$consulDir\data"

	# Print Consul version number to confirm it was downloaded correctly
	& $consulExePath version
}
else
{
	Write-Host "Consul is already installed"
}
