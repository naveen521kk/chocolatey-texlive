function LoadNuspecFile( $NuspecPath ) {
    $nu = New-Object xml
    $nu.PSBase.PreserveWhitespace = $true
    $nu.Load($NuspecPath)
    return $nu
}
$ReadmePath = "../texlive/ReadMe.md"
$NuspecPath = "../texlive/texlive.nuspec"
echo "Setting package description from $ReadmePath"
$SkipLast=0
$description = gc $ReadmePath -Encoding UTF8
$endIdx = $description.Length - $SkipLast
$description = $description | select -Index ($SkipFirst..$endIdx) | Out-String
$NuspecXml=$(LoadNuspecFile $NuspecPath)
$cdata = $NuspecXml.CreateCDataSection($description)
$xml_Description = $NuspecXml.GetElementsByTagName('description')[0]
$xml_Description.RemoveAll()
$xml_Description.AppendChild($cdata) | Out-Null
  
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
[System.IO.File]::WriteAllText($NuspecPath, $NuspecXml.InnerXml, $Utf8NoBomEncoding)
