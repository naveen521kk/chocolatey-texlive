function Get-MajorVersion {
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
        [string]$InstallLocation="$env:SystemDrive\texlive\$(Get-MajorVersion -Version $($env:ChocolateyPackageVersion) )",
        [string]$installType="full", #also called scheme
        [array]$collections=@(),
        [string]$workingDir="$env:TEMP"
    )
    #installType = "full","medium","small","basic","minimal","context","gust","infraonly","tetex","custom"
    Write-Host "TeX Live Profile will be written to $workingDir\texlive.profile" -ForegroundColor Yellow
    $finalProfileStr=""
    $finalProfileStr+="selected_scheme scheme-$($installType)`n" #select scheme
    $finalProfileStr+="TEXDIR $($InstallLocation)`n" #select texdir
    #collection loop
    if ($collections -ne $null){
        foreach ($coll in $collections)
            {
            $finalProfileStr+="collection-$coll 1`n"
        }
    }
    Set-Content -Path "$workingDir\texlive.profile" -Value "$finalProfileStr"
    Write-Debug "Written Profile in $workingDir\texlive.profile."
    return @{profileLoc="$workingDir\texlive.profile"}
  }
