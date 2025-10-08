$ErrorActionPreference = "Stop"

#run python script
pip install requests
#First Get install-tl thanks texlive.info
python writeVerificationFile.py
# fill readme
python readmefill.py

#run nuspec filler
./readmetonuspec.ps1

#bump version
./replaceversionNuspec.ps1

#write license
python setLicense.py
