$ErrorActionPreference = 'stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$toolsDir/helper.ps1"

$pp = Get-PackageParameters

# Check for additional parameters
$AdditionalInstallerParameters = ""
if ($pp['InstallerParameters']){
     $AdditionalInstallerParameters = $pp['InstallerParameters']
}
Write-Host "Additional parameters for installer: $AdditionalInstallerParameters"


if (!$pp['collections']) {
     $pp['collections'] = @()
}
else {
     if (($pp['collections']).GetType().BaseType.Name -ne "Array") {
          #checking whether array
          Write-Host "$($pp['collections']) is not an Array so converting to array." -ForegroundColor Yellow
          $pp['collections'] = ($pp['collections'] -split ",")
     }
}
if (!$pp['scheme']) {
     $pp['scheme'] = 'basic'
}
if (!$pp['InstallationPath']) {
     $pp['InstallationPath'] = "$env:SystemDrive\texlive\$(Get-MajorVersion "$env:ChocolateyPackageVersion")" 
}
if (!$pp['extraPackages']) {
     $pp['extraPackages'] = $null
}
else {
     if (($pp['extraPackages']).GetType().BaseType.Name -ne "Array") {
          #checking whether array
          Write-Host "$($pp['extraPackages']) is not an Array so converting to array." -ForegroundColor Yellow
          $pp['extraPackages'] = ($pp['extraPackages'] -split ",")
     }
}
$params = "/collections:$($pp['collections']) /scheme:$($pp['scheme']) /InstallationPath:$($pp['InstallationPath'])"
Write-Debug "Received Package Parameters: $params"
Write-Host "Writing Profile" -ForegroundColor Yellow
#write texlive profile
Write-Host "Writing Profile using Passed Parameters."

$profileArgs = @{
     InstallLocation = $pp['InstallationPath']
     installType     = $pp['scheme']
     collections     = $pp['collections']
     workingDir      = "$(Get-ToolsLocation)"
}
$profilelocation = Write-Profile @profileArgs
Write-Debug "Profile contents are `n $(gc $profilelocation.profileLoc)"
# extract install.zip
Write-Debug "Extracting and Moving Folders"
# this is done so that the line length doesn't exceeds.
$zipLocation=$toolsDir
$toolsDir="$(Get-ToolsLocation)\install-tl-$(Get-Date -Format ddMMyyHH)"
if (Test-Path -Path $toolsDir) {
     Write-Host "Removing $toolsDir as it already exists"
     Remove-Item -Path "$toolsDir" -Force -Recurse
}
Get-ChocolateyUnzip -FileFullPath "$zipLocation\install-tl.zip" -Destination "$toolsDir" -PackageName "Texlive Installer"
Move-Item -Path "$toolsDir\install-tl-*\*" -Destination "$toolsDir" -Force 

if ($pp['scheme'] -eq "infraonly") {
     Write-Debug "Setting `$ErrorActionPreference to continue as Infra Only install detected"
     $ErrorActionPreference = "continue";
}

Write-Debug "Setting Environment variables TEXLIVE_INSTALL_ENV_NOCHECK and TEXLIVE_INSTALL_NO_WELCOME"
$env:TEXLIVE_INSTALL_ENV_NOCHECK = $true #powershell throws error without this
$env:TEXLIVE_INSTALL_NO_WELCOME = $true

Write-Debug "Installer Version is $(& `"$($toolsDir)\install-tl-windows.bat`" -version)"
Write-Debug "Starting Installer with parameter -no-gui -profile=`"$($profilelocation.profileLoc)`""

& "$($toolsDir)\install-tl-windows.bat" -no-gui -profile="$($profilelocation.profileLoc)" $AdditionalInstallerParameters

if ($null -ne $pp['extraPackages']) {
     foreach ($c in $pp['extraPackages']) {
          Write-Host "Installing $c using tlmgr" -ForegroundColor DarkBlue
          $c = $c.Trim()
          & "$($pp['InstallationPath'])\bin\windows\tlmgr.bat" install $c
     }
     
}
$files = get-childitem $toolsDir -include *.exe -recurse
foreach ($file in $files) {
     New-Item "$file.ignore" -type file -force | Out-Null
}
Remove-Item -Path "$toolsDir" -Force -Recurse
