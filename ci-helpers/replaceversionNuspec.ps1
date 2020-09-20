function LoadNuspecFile( $NuspecPath ) {
    $nu = New-Object xml
    $nu.PSBase.PreserveWhitespace = $true
    $nu.Load($NuspecPath)
    return $nu
}
$versionFile= Resolve-Path "showversion.py"
$version = $(python $versionFile)

$NuspecPath = Resolve-Path "../texlive/texlive.nuspec"
Write-Output "Setting version to $NuspecPath"
$NuspecXml=$(LoadNuspecFile $NuspecPath)
$NuspecXml.package.metadata.version = $version.ToString()
  
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
[System.IO.File]::WriteAllText($NuspecPath, $NuspecXml.InnerXml, $Utf8NoBomEncoding)