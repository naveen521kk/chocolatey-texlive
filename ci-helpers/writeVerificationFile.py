import requests
import time
import hashlib
import os
from requests.exceptions import RequestException, HTTPError, Timeout, ConnectionError


def download_file(url, dest_path):
    print(f"Starting download from {url} to {dest_path}")
    try:
        # Send a GET request to the URL
        response = requests.get(
            url,
            stream=True,
            timeout=10,
            # pretend to be curl
            headers={"User-Agent": "curl/7.64.1"},
        )  # 10 seconds timeout

        # Raise an exception if the request was unsuccessful
        response.raise_for_status()

        # Open the destination file in binary write mode
        with open(dest_path, "wb") as file:
            # Iterate over the chunks of the file to download
            for chunk in response.iter_content(chunk_size=8192):
                if chunk:  # filter out keep-alive new chunks
                    file.write(chunk)

        print(f"Download completed successfully: {dest_path}")

    except HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}")

    except Timeout as timeout_err:
        print(f"Request timed out: {timeout_err}")

    except ConnectionError as conn_err:
        print(f"Connection error occurred: {conn_err}")

    except RequestException as req_err:
        print(f"An error occurred with the request: {req_err}")

    except Exception as err:
        print(f"An unexpected error occurred: {err}")


def calculate_sha256(file_path):
    """Calculate the SHA256 hash of a file."""
    sha256_hash = hashlib.sha256()  # Create a new SHA256 hash object

    try:
        with open(file_path, "rb") as file:
            # Read the file in chunks and update the hash object
            for byte_block in iter(lambda: file.read(4096), b""):
                sha256_hash.update(byte_block)

        # Return the hexadecimal digest of the hash
        return sha256_hash.hexdigest()

    except Exception as e:
        print(f"Error calculating SHA256 hash: {e}")
        return None


fileLoc = os.path.abspath(os.path.join(__file__, "../"))
verificationFileLoc = os.path.abspath(
    os.path.join(fileLoc, "../", "texlive", "tools", "VERIFICATION.txt")
)
installZipFile = os.path.abspath(
    os.path.join(fileLoc, "../", "texlive", "tools", "install-tl.zip")
)
timeNow = time.localtime()
urlTexZip = "https://texlive.info/tlnet-archive/{year}/{month}/{date}/tlnet/install-tl.zip".format(
    year=timeNow.tm_year,
    month=(
        "0" + str(timeNow.tm_mon) if len(str(timeNow.tm_mon)) == 1 else timeNow.tm_mon
    ),
    date=(
        "0" + str(timeNow.tm_mday)
        if len(str(timeNow.tm_mday)) == 1
        else timeNow.tm_mday
    ),
)

# con = requests.get(urlTexZip)

# con.raise_for_status()

# # save file
# with open(installZipFile, "wb") as f:
#     f.write(con.content)
download_file(urlTexZip, installZipFile)
print("Downloaded file to:", installZipFile)
FileChecksum = calculate_sha256(installZipFile)
print("File SHA256:", FileChecksum)

print("File URL:", urlTexZip)
VERIFICATION_TEXT = f"""
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
with open(verificationFileLoc, "w") as f:
    f.write(VERIFICATION_TEXT)
