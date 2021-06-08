$URL = "https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.13.1-windows-x86_64.zip"
$PATH = "C:\windows\temp\elastic-agent-7.13.1-windows-x86_64.zip"
$ProgressPreference = "SilentlyContinue"
Write-Output "Downloading"
Invoke-WebRequest $URL -OutFile $PATH
Write-Output "Extracting"
$DOWNLOADS = "C:/Users/adminuser/Downloads"
Expand-Archive -Force -LiteralPath $PATH -DestinationPath $DOWNLOADS
cd $DOWNLOADS\elastic-agent-7.13.1-windows-x86_64
.\elastic-agent.exe install -f --url=${kibana-url} --enrollment-token=${token}