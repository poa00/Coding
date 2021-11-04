# ------------------------------------------------------------
#
# Get/List installed package(s)/application(s)
#


$PackageNameContains="Help"; Get-AppxPackage | Sort-Object -Property Name | Where-Object { $_.Name -Like "*${PackageNameContains}*" };


$PackageNameContains="DynamicTheme"; Get-AppxPackage | Sort-Object -Property Name | Where-Object { $_.Name -Like "*${PackageNameContains}*" };


$PackageNameContains="Microsoft.WindowsTerminal"; Get-AppxPackage | Sort-Object -Property Name | Where-Object { $_.Name -Like "*${PackageNameContains}*" };


# ------------------------------------------------------------
#
# Run a local package/application 
#


# As a one-liner:
SV AppNameContains (Write-Output Microsoft.WindowsTerminal); explorer.exe shell:AppsFolder\$(Get-AppxPackage | Where-Object { ((((GV _).Value).Name).Contains(((GV AppNameContains).Value))) -Eq $True } | Select-Object -ExpandProperty PackageFamilyName;)!App;


# Expanded:
If ($True) {
$AppNameContains="Microsoft.WindowsTerminal";
$AppNameResolved=(Get-AppxPackage | Where-Object { ("$($_.Name)".Contains("${AppNameContains}")) -Eq $True } | Select-Object -ExpandProperty "PackageFamilyName");
explorer.exe shell:AppsFolder\$(Write-Output ${AppNameResolved};)!App;
}


# ------------------------------------------------------------
#
# Uninstall package(s)/application(s)
#

$RemovePackagesContaining="Xbox"; Get-AppxPackage | Where-Object { $_.Name -Like "*${RemovePackagesContaining}*" } | Remove-AppxPackage;


# ------------------------------------------------------------
#
# Install package(s)/application(s)   (via an installation file "Appxmanifest.xml" (standardized filename))
#

Get-ChildItem -Path ("${Home}\Desktop") -File -Recurse -Force -ErrorAction "SilentlyContinue" `
| Where-Object { ($_.Name -Eq "Appxmanifest.xml") -Or ($_.Name -Like "*.msix") } `
| ForEach-Object { Add-AppxPackage -Path ("$($_.FullName)") -Register -DisableDevelopmentMode; }


# ------------------------------------------------------------
#
# Show available "*Appx*" cmdlets
#
Get-Command | Where-Object { $_.Name -Like '*appx*' };



# ------------------------------------------------------------
#
# Search for local package/application manifests & installation files
#

Get-ChildItem -Path ("${Home}\Desktop") -File -Recurse -Force -ErrorAction "SilentlyContinue" | Where-Object { ($_.Name -Eq "Appxmanifest.xml") -Or ($_.Name -Like "*.msix") };


# ------------------------------------------------------------
# Citation(s)
#
#  docs.microsoft.com  |  "Add-AppxPackage - Adds a signed app package to a user account"  |  https://docs.microsoft.com/en-us/powershell/module/appx/add-appxpackage?view=win10-ps
#
#  stackoverflow.com  |  "How to Start a Universal Windows App (UWP) from PowerShell in Windows 10?"  |  https://stackoverflow.com/a/48856168
#
# ------------------------------------------------------------