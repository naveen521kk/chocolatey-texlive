$ErrorActionPreference = 'Stop'; # stop on all errors

[array]$key = Get-UninstallRegistryKey -SoftwareName "Tex Live*"

if ($key.Count -eq 1) {
  $key | % { 
    $uninstStr = "$($_.UninstallString)".split('"') #should contain no quotes
	Write-Debug "Uninstall String was $uninstStr adding '--no-confirm' parameter"
	& "$uninstStr" --no-confirm
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
