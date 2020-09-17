# TeX Live Installer

![texlive-logo](https://cdn.jsdelivr.net/gh/naveen521kk/chocolatey-texlive@master/texlive/texlive.svg)

TeX Live is intended to be a straightforward way to get up and running with the TeX document production system. It provides a comprehensive TeX system with binaries for most flavors of Unix, including GNU/Linux, macOS, and also Windows. It includes all the major TeX-related programs, macro packages, and fonts that are free software, including support for many languages around the world.

This *Chocolatey Package* makes the process of installing TeX Live on CI/CD or No GUI computers but not limited to users to install on their Personal Computers.

## Package Specific
#### Package Parameters
The following package parameters can be set:

 * `/collections:` - The TeX Live Collection to install. Default to None. Allowed values are listed [here](#allowed-values-collections).
 * `/scheme:` - The scheme you need to install. Defaults to scheme-full. Allowed values are listed [here](#allowed-values-schemes).
 * `/InstallationPath:` - Where to install the binaries to - defaults to "`$env:SystemDrive\texlive\<version major>`"

To pass parameters, use `--params "''"` (e.g. `choco install texlive [other options] --params="'/collections:games /scheme:basic'"`).
To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Allowed Values Collections
<!--To be automatically filled.-->
<!--collections Start-->

<!--collections End-->

### Allowed Values Schemes
<!--To be automatically filled.-->
<!--schemes Start-->

<!--schemes End-->

Note: This Package is automatically Maintained and if issues faced contact the Maintainer.