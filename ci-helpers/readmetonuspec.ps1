$ReadmePath = "../texlive/ReadMe.md"
$NuspecPath = "../texlive/texlive.nuspec"
$SkipLast=0
Write-Host 'Setting $ReadmePath to Nuspec description tag'
$description = Get-Content $ReadmePath -Encoding UTF8
$endIdx = $description.Length - $SkipLast
$description = $description | Select-Object -Index ($SkipFirst..$endIdx) | Out-String

$nu =  Get-Content $NuspecPath -Raw
$nu = $nu -replace "(?smi)(\<description\>).*?(\</description\>)", "`${1}$($description)`$2"

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
$NuPath = (Resolve-Path $NuspecPath)
[System.IO.File]::WriteAllText($NuPath, $nu, $Utf8NoBomEncoding)