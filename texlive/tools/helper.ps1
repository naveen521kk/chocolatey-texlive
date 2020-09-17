function Get-MajorVersion {
    [CmdletBinding()]
    param(
        # Version string to parse.
        [Parameter(Mandatory=$true)]
        [string] $Version
    )
    $temp=$Version.Replace(".","-")
    $temp=$($temp -split "-")
    return $temp[0]
}
function Write-Profile {
    [CmdletBinding()]
    param (
        [System.IO.Path]$InstallLoc="$env:SystemDrive\texlive\$(Get-MajorVersion -Version $($env:ChocolateyPackageVersion) )",
        [string]$installType="full",
        [System.IO.Path]$workingDir="$env:TEMP"
    )
    #installType = "full","medium","small","basic","minimal","context","gust","infraonly","tetex","custom"

    $finalProfileStr="`n"
    $finalProfileStr+="selected_scheme scheme-$($installType)`n"
    #TODO Collections
    $finalProfileStr+="TEXDIR $(InstallLoc)`n"
    Set-Content -Path "$workingDir\texlive.profile" -Value "$finalProfileStr"
    return @{profileLoc="$workingDir\texlive.profile"}
  }
