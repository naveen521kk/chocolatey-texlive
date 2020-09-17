#First Get install-tl thanks texlive.info
Set-Location ../texlive
Invoke-WebRequest -Uri "https://texlive.info/tlnet-archive/2020/09/17/tlnet/install-tl.zip" -OutFile "install-tl.zip"
Set-Location ../

#run python script
Set-Location ci-helpers
python readmefill.py

#run nuspec filler
./readmetonuspec.ps1
