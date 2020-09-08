import bs4
import pandas as pd
import urllib.request
import json

def generateURL(index):
    base = "https://drugbank.vn/services/drugbank/api/public/thuoc?"
    page = "page="
    otherconfig = "&size=12&tenThuoc=A&sort=rate,desc&sort=tenThuoc,asc"
    return base + page + str(index) + otherconfig

def get_page_content(url):
    page = urllib.request.urlopen(url)
    return bs4.BeautifulSoup(page,"html.parser")

f = open("drugbank1.txt", "a")
for i in range(2000, 3000):
    url = generateURL(i)
    print(url)
    soup = get_page_content(url)

    jsonData = json.loads(str(soup))

    for item in range(0, len(jsonData)):
        name = jsonData[item]['tenThuoc']
        f.write(name + '\n')
        print(name)

f.close()