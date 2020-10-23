# TeX Live Installer

![texlive-logo](https://cdn.jsdelivr.net/gh/naveen521kk/chocolatey-texlive@master/icons/texlive.svg)

TeX Live is intended to be a straightforward way to get up and running with the TeX document production system. It provides a comprehensive TeX system with binaries for most flavors of Unix, including GNU/Linux, macOS, and also Windows. It includes all the major TeX-related programs, macro packages, and fonts that are free software, including support for many languages around the world.

This _Chocolatey Package_ makes the process of installing TeX Live on CI/CD or No GUI computers but not limited to users to install on their Personal Computers.

## Package Specific

#### Package Parameters

The following package parameters can be set:

- `/collections:` - The TeX Live Collection to install. Default to None. Data type is comma seperated string. Allowed values are listed [here](#allowed-values-collections).
- `/scheme:` - The scheme(type) you need to install. Defaults to scheme-basic. Should be a string. Allowed values are listed [here](#allowed-values-schemes).
- `/InstallationPath:` - Where to install the binaries to - defaults to "`$env:SystemDrive\texlive\<version major>`"
- `/extraPackages:` - Extra LaTeX Packages that need to be installed using tlmgr. If multiple packages it needs comma seperated.

To pass parameters, use `--params "''"` (e.g. `choco install texlive [other options] --params="'/collections:games /scheme:basic'"`).
To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Allowed Values Collections


- basic
- bibtexextra
- binextra
- context
- fontsextra
- fontsrecommended
- fontutils
- formatsextra
- games
- humanities
- langarabic
- langchinese
- langcjk
- langcyrillic
- langczechslovak
- langenglish
- langeuropean
- langfrench
- langgerman
- langgreek
- langitalian
- langjapanese
- langkorean
- langother
- langpolish
- langportuguese
- langspanish
- latex
- latexextra
- latexrecommended
- luatex
- mathscience
- metapost
- music
- pictures
- plaingeneric
- pstricks
- publishers
- texworks
- wintools
- xetex


### Allowed Values Schemes


- basic
- context
- full
- gust
- infraonly
- medium
- minimal
- small
- tetex


Note: This Package is automatically Maintained and if issues faced contact the Maintainer.

Sponsor Norbert Preining for https://texlive.info without which this is not possible.

[![sponser](https://cdn.jsdelivr.net/gh/naveen521kk/chocolatey-texlive@master/icons/sponsor.svg)](https://github.com/sponsors/norbusan)