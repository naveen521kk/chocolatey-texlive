#First Get install-tl thanks texlive.info
Set-Location ../texlive/tools
Invoke-WebRequest -Uri "http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip" -OutFile "install-tl.zip"
Set-Location ../../

#run python script
Set-Location ci-helpers
pip install requests
python readmefill.py

#run nuspec filler
./readmetonuspec.ps1

#bump version
./replaceversionNuspec.ps1

#write license
python setLicense.py
