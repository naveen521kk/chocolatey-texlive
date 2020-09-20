import requests
import time

timeNow = time.localtime()
urlTexZip = "https://texlive.info/tlnet-archive/{year}/{month}/{date}/tlnet/install-tl.zip".format(
    year=timeNow.tm_year,
    month="0"+str(timeNow.tm_mon) if len(str(timeNow.tm_mon))==1 else timeNow.tm_mon,
    date=timeNow.tm_mday
)
print("File URL:",urlTexZip)
VERIFICATION_TEXT="""

VERIFICATION

Verification is intended to assist the Chocolatey moderators and community
in verifying that this package's contents are trustworthy.
"""
