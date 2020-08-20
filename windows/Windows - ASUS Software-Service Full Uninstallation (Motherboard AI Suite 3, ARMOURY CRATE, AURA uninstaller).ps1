# ------------------------------------------------------------
#
# ASUS SOFTWARE REMOVAL
#  |
#  |-->  https://rog.asus.com/forum/showthread.php?114773-Armoury-Crate-not-recognizing-devices-and-unable-to-control-RGB#post794749
#  |
#  |-->  https://www.reddit.com/r/pcmasterrace/comments/eyqieh/asus_armoury_crateaura_complete_removal/
#
#
# ------------------------------------------------------------
#
# UNINSTALL THE FOLLOWING PROGRAM(S) (Win7 style exes) by opening "appwiz.cpl" ("Programs and Features") and right-clicking -> selecting "Uninstall" on each (wait til all are uninstalled to restart)
#

#  > FIND IN "appwiz.cpl", THEN UNINSTALL:

All MB   <# *** UNINSTALL VIA BIOS - SEE BELOW FOR DETAILED INFO *** #>

AI Suite 3
AMD Software
AMD_Chipset_Drivers
ARMOURY CRATE Lite Service
ASUS Framework Service
AURA
AURA lighting effect add-on
AURA lighting effect add-on x64
AURA Service
GALAX GAMER RGB
ROG Live Service


# ------------------------------------------------------------
#
# UNINSTALL THE FOLLOWING APPLICATION(S) (Win10 style apps) by [ typing their name into the start menu, then right-clicking them and selecting "Uninstall" ]. Alternatively, uninstall them by [ opening "Apps & features" then left-clicking the app and selecing "Uninstall" ]:
#

#  > FIND VIA START-MENU, THEN UNINSTALL:

ARMOURY CRATE
AURA Creator


# ------------------------------------------------------------
#
# REMOVE ASUS SERVICES
#

If ($True) {
	
	<# FIND/REMOVE SERVICES #>
	Get-Service -ErrorAction "SilentlyContinue" `
	| Where-Object { `
		(($_.Name -Like "ASUS*") -Or ($_.DisplayName -Like "ASUS*")) `
		-Or (($_.Name -Like "ROG Live*") -Or ($_.DisplayName -Like "ROG Live*")) `
		-Or (($_.Name -Like "ARMOURY CRATE*") -Or ($_.DisplayName -Like "ARMOURY CRATE*")) `
	} | ForEach-Object {
		$_ | Stop-Service;
		Start-Sleep -Milliseconds (250);
		Write-Host "`nInfo: Deleting Service w/ Name = `"$($_.Name)`", DisplayName = `"$($_.DisplayName)`" ...  " -ForegroundColor "Yellow";
		Start-Process -Filepath ("C:\Windows\system32\sc.exe") -ArgumentList (@("delete","$($_.Name)")) -Verb ("RunAs") -ErrorAction ("SilentlyContinue");
		Start-Sleep -Milliseconds (250);
	};

}


# ------------------------------------------------------------
#
# REMOVE ASUS FILES & DIRECTORIES 
#

If ($True) {

	$Paths_ToDelete = @();

	$Paths_ToDelete += "C:\Program Files\ASUS";
	$Paths_ToDelete += "C:\Program Files (x86)\ASUS";
	$Paths_ToDelete += "C:\Program Files (x86)\InstallShield Installation Information\{93795eb8-bd86-4d4d-ab27-ff80f9467b37}"; # --> A --> Enter
	$Paths_ToDelete += "C:\ProgramData\ASUS";
	$Paths_ToDelete += "${Env:LocalAppData}\ASUS";
	$Paths_ToDelete += "C:\Windows\System32\AsusDownloadAgent.exe";
	$Paths_ToDelete += "C:\Windows\System32\AsusDownLoadLicense.exe";
	$Paths_ToDelete += "C:\Windows\System32\AsusUpdateCheck.exe";

	$Paths_ToDelete | ForEach-Object {
		$Each_PathToDelete = "$_";
		If (Test-Path -Path ("${Each_PathToDelete}")) {
			Write-Host "Removing Path `"${Each_PathToDelete}`" ...";
			Remove-Item -Path ("$Each_PathToDelete") -Recurse -Force -Confirm:$false;
		};
	};

}


# ------------------------------------------------------------
#
# REMOVE ASUS REGISTRY ENTRIES
#

If ($True) {

	$Paths_ToDelete = @();

	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\AsRogAuraService.ServiceMediator.1";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\AsRogAuraService.ServiceMediator";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\AsRogAuraService.AuraSdkManager.1";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\AsRogAuraService.AuraSdkManager";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\asus.aura";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\asus.aura.1";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUS.OneClickCtrl.9";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUS.Update3WebControl.3";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\asusac";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSAuraExtCardHal.Hal.1";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSAuraMBHal.Hal";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSAuraMBHal.Hal.1";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSAuraOddHal.Hal";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSAuraOddHal.Hal.1";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUS-Display.Hal";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUS-Display.Hal.1.0.2";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSGCDriverInitialClient";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSGCDriverUpdateClient";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\AsusGCGridServiceSetup";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.CoCreateAsync";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.CoCreateAsync.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.CoreClass";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.CoreClass.1";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.CoreMachineClass";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.CoreMachineClass.1";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.CredentialDialogMachine";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.CredentialDialogMachine.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.OnDemandCOMClassMachine";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.OnDemandCOMClassMachine.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.OnDemandCOMClassMachineFallback";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.OnDemandCOMClassMachineFallback.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.OnDemandCOMClassSvc";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.OnDemandCOMClassSvc.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.ProcessLauncher";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.ProcessLauncher.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.Update3COMClassService";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.Update3COMClassService.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.Update3WebMachine";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.Update3WebMachine.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.Update3WebMachineFallback";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.Update3WebMachineFallback.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.Update3WebSvc";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\ASUSUpdate.Update3WebSvc.1.0";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\aura.sdk";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\aura.sdk.1";
	$Paths_ToDelete += "Registry::HKEY_CURRENT_USER\Software\ASUS";
	$Paths_ToDelete += "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\ASUS";

	$Paths_ToDelete | ForEach-Object {
		$Each_PathToDelete = "$_";
		If (Test-Path -Path ("${Each_PathToDelete}")) {
			Write-Host "Removing Path `"${Each_PathToDelete}`" ...";
			Remove-Item -Path ("$Each_PathToDelete") -Recurse -Force -Confirm:$false;
		};
	};

	#
	# Locating remaining registry keys to-delete (based on specific hardware) #>
	#   |
	#   |--> Download ASUS Aura (Zip file) - Do not install it, but rather open the packaged directory "LightingService\aac" and locate the target "Aac...exe" file for the hardware which you previously configured RGB/ARGB on. e.g. for motherboards, use "AacMBSetup.exe" #>
	#   |
	#   |--> Open a command prompt, change directory to the "LightingService\aac" directory, and run the following command (replacing associated .exe as-needed): #>
	#         |
	#         |--> AacMBSetup.exe -install -log log.txt
	#         |
	#         |--> Run the setup, walkthrough it as-normal, then open log.txt
	#         |
	#         |--> Search for lines containing, SPECIFICALLY:
	#         |      "Detected related package"   <-- These lines contain the {...GUIDs...} for old, deprecated versions of the ASUS AURA HAL AAC Driver which should be removed/uninstalled
	#         |
	#         |--> Search these lines for GUIDs wrapped with curly-braces within the log file, and copy the interior string (without the curly-braces).
	#         |
	#         |--> Open regedit.exe > select "Computer" (top-left) to select the entire registry
	#         |
	#         |--> Search (CTRL + F) the entire Computer (the "entire local registry") for the copied GUID
	#         |
	#         |--> For any keys that it finds, back them up to a temporary storage location of your choice (such as desktop), then delete them
	#         |       (USE THE FOLLOWING SCRIPT - REPLACE GUID AT END OF STRINGS)
	#         |
	#         |--> Once complete, rerun the previous driver installation .exe command (the one using -install -log log.txt)
	#

	$Paths_ToDelete = @();
	$Paths_ToDelete += "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Dependencies\{D800D836-DE15-4B00-8273-521F022CD837}";
	$Paths_ToDelete += "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D800D836-DE15-4B00-8273-521F022CD837}";
	$Paths_ToDelete += "Registry::HKEY_CLASSES_ROOT\Installer\Dependencies\{D800D836-DE15-4B00-8273-521F022CD837}";

	$Paths_ToDelete | ForEach-Object {
		$Each_PathToDelete = "$_";
		If (Test-Path -Path ("${Each_PathToDelete}")) {
			Write-Host "Removing Path `"${Each_PathToDelete}`" ...";
			Remove-Item -Path ("$Each_PathToDelete") -Recurse -Force -Confirm:$false;
		};
	};

}


# ------------------------------------------------------------
#
# "All MB" - UNINSTALL / REMOVE APP
#
If ($True) {
	#
	# Application “All MB” must be disabled/uninstalled by stopping it from the BIOS
	#
	# Step 1/2 - Enter your device’s BIOS:
	#  |
	#  |--> From Windows:
	#  |     |--> Open the Start Menu
	#  |     |--> Type “UEFI” into start menu
	#  |     |--> Select “Change advanced startup options”
	#  |     |--> Select “Restart now”
	#  |     |--> Wait for blue screen options...
	#  |     |--> Select “Troubleshoot”
	#  |     |--> Select “Advanced options”
	#  |     |--> Select “UEFI Firmwate Settings”
	#  |     |--> Select “Restart”
	#  |
	#  |--> From POST (during your device’s power-on/boot up phase)
	#        |--> Spam either F2 or Delete (depending on your motherboard specification) on the keyboard to enter BIOS 
	#        |--> Stop spamming F2 or Delete (depending on your motherboard specification) if the windows loading icon appears (as it is too late by then, and BIOS likely needs to be entered thru windows - see previous step or retry by rebooting)
	#
	# Step 2/2 - Once you’re in the BIOS, disable Armoury Crate:
	#  |--> Hit F7 for Advanced
	#  |--> Goto tab “Tools”
	#  |--> Select “ASUS Armoury Crate”
	#  |--> Set option “Download & Install ARMOURY CRATE app” to “Disabled”
	#
}



# ------------------------------------------------------------
#
# Citation(s)
#
#   docs.microsoft.com  |  "Get-ChildItem - Gets the items and child items in one or more specified locations"  |  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?view=powershell-5.1
#
#   docs.microsoft.com  |  "Remove-Item - Deletes the specified items"  |  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/remove-item?view=powershell-5.1
#
# ------------------------------------------------------------