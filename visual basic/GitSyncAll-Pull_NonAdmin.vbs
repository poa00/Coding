CreateObject( "WScript.Shell" ).Run "PowerShell -Command ""[System.Net.ServicePointManager]::SecurityProtocol=[System.Net.SecurityProtocolType]::Tls12; $ProgressPreference='SilentlyContinue'; Clear-DnsClientCache; Set-ExecutionPolicy 'RemoteSigned' -Scope 'CurrentUser' -Force; Try { Invoke-Expression ((Invoke-WebRequest -UseBasicParsing -TimeoutSec (7.5) -Uri ('https://raw.githubusercontent.com/mcavallo-git/Coding/main/powershell/_WindowsPowerShell/Modules/GitSyncAll/GitSyncAll.psm1') ).Content) } Catch {}; If (-Not (Get-Command -Name 'GitSyncAll' -ErrorAction 'SilentlyContinue')) { Import-Module ([String]::Format('{0}\Coding\powershell\_WindowsPowerShell\Modules\GitSyncAll\GitSyncAll.psm1', (gc env:\\REPOS_DIR))); }; GitSyncAll -Pull;"" ", 0, True

' ------------------------------------------------------------
'
' Create a Scheduled Task (which targets this script) by using the following values:
'
'   Name/Description:
'     GitSyncAll-Pull_NonAdmin
'
'   Security Options:
'     Run only when user is logged on (CHECKED)
'     Run whether user is logged on or not (UN-CHECKED)
'     Run with highest privileges (UN-CHECKED)
'
'   Trigger:
'     At log on of [current user] (delay task for 15 seconds)
'     On workstation unlock of [current user] (no delay)
'
'   Action:
'     Program/script:   C:\Windows\System32\wscript.exe
'     Add arguments:    "%USERPROFILE%\Documents\GitHub\Coding\visual basic\GitSyncAll-Pull_NonAdmin.vbs"
'
'   Conditions:
'     (UN-CHECK) Start the task only if the computer is on AC power
'     (CHECK)    Start only if the following network connection is available: [ Any connection ]
'
'   Settings:
'     (CHECK)    Stop this task if it runs longer than:  15 minutes
'     (CHECK)    If the task is already running, then the following rule applies: [ Do not start a new instance ]
'
'
' ------------------------------------------------------------
'
' Citation(s)
'
'   git-scm.com  |  "Git"  |  https://git-scm.com
'
' ------------------------------------------------------------