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
Write-Debug "Recieved Package Parameters: $params"
Write-Host "Writing Profile" -ForegroundColor Yellow
#write texlive profile
Write-Host "Writing Profile using Passed Parameters."

$profileArgs = @{
     InstallLocation=$pp['InstallationPath']
     installType=$pp['scheme']
     collections=$pp['collections']
     workingDir="$($PWD)"
}
$profilelocation = Write-Profile @profileArgs

# extract install.zip
Get-ChocolateyUnzip -FileFullPath "$toolsDir\install-tl.zip" -Destination "$toolsDir" -PackageName "texlive"
Move-Item -Path "$toolsDir\install-tl-*\*" -Destination "$toolsDir" -Force 

$env:TEXLIVE_INSTALL_ENV_NOCHECK=$true #powershell throws error without this
$env:TEXLIVE_INSTALL_NO_WELCOME=$true
& "$($toolsDir)\install-tl-windows.bat" -no-gui -profile="$($profilelocation.profileLoc)"

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
