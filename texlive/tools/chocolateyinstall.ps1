$ErrorActionPreference = 'continue'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$toolsDir/helper.ps1"

$pp = Get-PackageParameters
if (!$pp['collections']) {
     $pp['collections'] = @()
} else {
     if (($pp['collections']).GetType().BaseType.Name -ne "Array"){ #checking whether array
          Write-Host "$($pp['collections']) is not an Array so converting to array." -ForegroundColor Yellow
          $pp['collections']=($pp['collections'] -split ",")
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
 } else {
     if (($pp['extraPackages']).GetType().BaseType.Name -ne "Array"){ #checking whether array
          Write-Host "$($pp['extraPackages']) is not an Array so converting to array." -ForegroundColor Yellow
          $pp['extraPackages']=($pp['extraPackages'] -split ",")
     }
 }
$params = "/collections:$($pp['collections']) /scheme:$($pp['scheme']) /InstallationPath:$($pp['InstallationPath'])"
Write-Debug "Received Package Parameters: $params"
Write-Host "Writing Profile" -ForegroundColor Yellow
#write texlive profile
Write-Host "Writing Profile using Passed Parameters."

$profileArgs = @{
     InstallLocation=$pp['InstallationPath']
     installType=$pp['scheme']
     collections=$pp['collections']
     workingDir="$($env:TEMP)"
}
$profilelocation = Write-Profile @profileArgs
Write-Debug "Profile contents are `n $(gc $profilelocation.profileLoc)"
# extract install.zip
Write-Debug "Extracting and Moving Folders"
Get-ChocolateyUnzip -FileFullPath "$toolsDir\install-tl.zip" -Destination "$toolsDir" -PackageName "texlive"
Move-Item -Path "$toolsDir\install-tl-*\*" -Destination "$toolsDir" -Force 

Write-Debug "Setting Environment variables TEXLIVE_INSTALL_ENV_NOCHECK and TEXLIVE_INSTALL_NO_WELCOME"
$env:TEXLIVE_INSTALL_ENV_NOCHECK=$true #powershell throws error without this
$env:TEXLIVE_INSTALL_NO_WELCOME=$true

#Write-Debug "Installer Version is $(& "$($toolsDir)\install-tl-windows.bat" -version)"
Write-Debug "Starting Installer with parameter -no-gui -profile=`"$($profilelocation.profileLoc)`""
tree /A /F $toolsDir
#& "$($toolsDir)\install-tl-windows.bat" -no-gui -profile="$($profilelocation.profileLoc)"
cmd.exe /C "`"$($toolsDir)\install-tl-windows.bat`" -no-gui -profile=`"$($profilelocation.profileLoc)`""

if ($null -ne $pp['extraPackages']){
     foreach ($c in $pp['extraPackages']){
          Write-Host "Installing $c using tlmgr" -ForegroundColor DarkBlue
          $c=$c.Trim()
          & "$($pp['InstallationPath'])\bin\win32\tlmgr.bat" install $c
      }
     
}
$files = get-childitem $toolsDir -include *.exe -recurse
foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}
