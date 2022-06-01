"""This script get the collection list from texlive.tlpdb and fills it into
``ReadMe.md`` """

import os

import requests

fileLoc = os.path.abspath(os.path.join(__file__, "../"))
readmePath = os.path.abspath(os.path.join(fileLoc, "../", "texlive", "ReadMe.md"))

# get texlive.tlpdb
whereTlpdb = "http://mirror.ctan.org/systems/texlive/tlnet/tlpkg/texlive.tlpdb"
con = requests.get(whereTlpdb)

# get collection list scheme list
collectionList = []
schemeList = []
content = con.text
for i in content.split("\n"):
    if "name collection-" in i:
        collectionList.append(i.split("-")[-1])
    if "name scheme-" in i:
        schemeList.append(i.split("-")[-1])
print(collectionList, schemeList)

# Write to ``Readme.md``
with open(readmePath) as f:
    readme = f.read()
collectionTextMD = "- " + "\n- ".join(collectionList)
schemeTextMD = "- " + "\n- ".join(schemeList)

readme = f"""# TeX Live Installer

![texlive-logo](https://cdn.jsdelivr.net/gh/naveen521kk/chocolatey-texlive@master/icons/texlive.svg)

TeX Live is intended to be a straightforward way to get up and running with the TeX document production system. It provides a comprehensive TeX system with binaries for most flavors of Unix, including GNU/Linux, macOS, and also Windows. It includes all the major TeX-related programs, macro packages, and fonts that are free software, including support for many languages around the world.

This _Chocolatey Package_ makes the process of installing TeX Live on CI/CD or No GUI computers but not limited to users to install on their Personal Computers.

**You would need to specify a [larger timeout](https://docs.chocolatey.org/en-us/configuration#timeouts) depending on your install**.

## Package Specific

#### Package Parameters

The following package parameters can be set:

- `/collections:` - The TeX Live Collection to install. Default to None. Data type is comma separated string. Allowed values are listed [here](#allowed-values-collections).
- `/scheme:` - The scheme(type) you need to install. Defaults to scheme-basic. Should be a string. Allowed values are listed [here](#allowed-values-schemes).
- `/InstallationPath:` - Where to install the binaries to - defaults to "`$env:SystemDrive\\texlive\\<version major>`"
- `/extraPackages:` - Extra LaTeX Packages that need to be installed using tlmgr. If multiple packages it needs comma separated.

To pass parameters, use `--params "''"` (e.g. `choco install texlive [other options] --params="'/collections:games /scheme:basic'"`).
To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Allowed Values Collections


{collectionTextMD}


### Allowed Values Schemes


{schemeTextMD}


Note: This Package is automatically Maintained and if issues faced contact the Maintainer.

Sponsor Norbert Preining for https://texlive.info without which this is not possible.

[![sponsor](https://cdn.jsdelivr.net/gh/naveen521kk/chocolatey-texlive@master/icons/sponsor.svg)](https://github.com/sponsors/norbusan)
"""

with open(readmePath, "w") as f:
    f.write(readme)
print("Sucessfully Written to ReadMe.md")
