#Download and Deploy Elastic Agent
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

#Domain Provisioning
Install-windowsfeature AD-domain-services
Import-Module ADDSDeployment
$password = ConvertTo-SecureString "P@$$w0rd1234!" -AsPlainText -Force
Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode "Win2012R2" -DomainName "${domain-name}" -DomainNetbiosName "${netbios-name}" -ForestMode "Win2012R2" -NoRebootOnCompletion:$false -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true
shutdown -r -t 10
exit 0