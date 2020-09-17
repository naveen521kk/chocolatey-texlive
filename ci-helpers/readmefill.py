"""This script get the collection list from texlive.tlpdb and fills it into
``ReadMe.md`` """

import requests

readmePath = "../texlive/ReadMe.md"
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
collectionTextMD = "- "+"\n- ".join(collectionList)
schemeTextMD = "- "+"\n- ".join(schemeList)

readme = (
    readme.split("<!--schemes Start-->")[0]
    + "<!--schemes Start-->\n"
    + schemeTextMD
    + "\n<!--schemes End-->"
    + readme.split("<!--schemes End-->")[1]
)
readme = (
    readme.split("<!--collections Start-->")[0]
    + "<!--collections Start-->\n"
    + collectionTextMD
    + "\n<!--collections End-->"
    + readme.split("<!--collections End-->")[1]
)
with open(readmePath,"w") as f:
    f.write(readme)
