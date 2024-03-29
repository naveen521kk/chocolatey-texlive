import requests
import time
import hashlib
import os

fileLoc=os.path.abspath(os.path.join(__file__,"../"))
verificationFileLoc=os.path.abspath(os.path.join(fileLoc,"../","texlive","tools","VERIFICATION.txt"))
installZipFile=os.path.abspath(os.path.join(fileLoc,"../","texlive","tools","install-tl.zip"))
timeNow = time.localtime()
urlTexZip = "https://texlive.info/tlnet-archive/{year}/{month}/{date}/tlnet/install-tl.zip".format(
    year=timeNow.tm_year,
    month="0"+str(timeNow.tm_mon) if len(str(timeNow.tm_mon))==1 else timeNow.tm_mon,
    date="0"+str(timeNow.tm_mday) if len(str(timeNow.tm_mday))==1 else timeNow.tm_mday
)

con=requests.get(urlTexZip)

con.raise_for_status()

# save file
with open(installZipFile,'wb') as f:
    f.write(con.content)
FileChecksum = hashlib.sha256(con.content).hexdigest()

print("File URL:",urlTexZip)
VERIFICATION_TEXT=f"""
VERIFICATION

Verification is intended to assist the Chocolatey moderators and community
in verifying that this package's contents are trustworthy.

Package can be verified like this:

1. Go to

   url: {urlTexZip}

   to download the zip file `install-tl.zip`.

2. You can use one of the following methods to obtain the SHA256 checksum:
   - Use powershell function 'Get-FileHash'
   - Use Chocolatey utility 'checksum.exe'

   checksum: {FileChecksum}

File 'license.txt' is obtained from:
   https://www.tug.org/texlive/LICENSE.TL


Note: The site https://texlive.info is maintained by Norbert Preining,
who is one of the maintainers of TeX Live and also board member of 
the TeX User Group TUG. That site provides a daily archive of all 
TeX Live packages as discussed in 
https://www.tug.org/pipermail/tex-live/2020-September/046056.html


Tex Live maintainer updates the installer daily to CTAN,official 
download place as mentioned in 
https://www.tug.org/texlive/acquire-netinstall.html
so the included `install-tl.zip` is a copy of the file, located at 
http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip 
when the package was published and can be verified from the site
https://texlive.info using the steps above.
"""
with open(verificationFileLoc,"w") as f:
    f.write(VERIFICATION_TEXT)
