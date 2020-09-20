import requests
import os
fileLoc=os.path.abspath(os.path.join(__file__,"../"))
licenseLoc=os.path.abspath(os.path.join(fileLoc,"../","texlive","tools","LICENSE.txt"))
print("License file at:",licenseLoc)
con=requests.get("https://www.tug.org/texlive/LICENSE.TL")
mainLic="""From: https://www.tug.org/texlive/LICENSE.TL

LICENSE

"""+con.text
with open(licenseLoc,"w") as f:
    f.write(mainLic)