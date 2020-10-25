import time
if time.localtime().tm_year==2020:
    print(time.strftime("%Y.1%Y%m%d"))
else:
    print(time.strftime("%Y.%Y%m%d"))
