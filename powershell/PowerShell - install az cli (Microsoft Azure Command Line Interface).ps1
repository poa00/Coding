<# Install Az CLI #> PowerShell -Command "If (GCM pwsh -ErrorAction SilentlyContinue) { SV PS ((GCM pwsh).Source); } Else { SV PS ((GCM powershell).Source); }; Start-Process -Filepath ((GV PS).Value) -ArgumentList ('-Command Write-Host (Write-Output Installing` Az` CLI...); Set-Location ((GCI env:\TEMP).Value); SV ProgressPreference SilentlyContinue; Invoke-WebRequest -UseBasicParsing -Uri (Write-Output https://aka.ms/installazurecliwindows) -OutFile (Write-Output .\AzureCLI.msi); Start-Process ((GCM msiexec).Source) -ArgumentList (Write-Output /I` AzureCLI.msi` /quiet) -Wait; Start-Sleep -Seconds 5;') -Verb RunAs -Wait -PassThru | Out-Null; Write-Host (Write-Output Close` and` reopen` terminal` to` use` az` command);";