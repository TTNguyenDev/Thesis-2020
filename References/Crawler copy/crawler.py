import bs4
# import pandas as pd
import urllib.request
import json
import re
import time


def generateURL(index):
    base = "https://drugbank.vn/services/drugbank/api/public/thuoc?"
    page = "page="
    otherconfig = "&size=12&tenThuoc=A&sort=rate,desc&sort=tenThuoc,asc"
    return base + page + str(index) + otherconfig

def get_page_content(url):
    page = urllib.request.urlopen(url)
    return bs4.BeautifulSoup(page,"html.parser")

def preprocessMedicineContain(contains):
    contains = re.sub('\([^)]*\)', '', contains)
    contains = contains.split(";")
    test_list = [i.strip() for i in contains if i != ' ']
    
    return test_list

start = 1
end = 1000
medicine_list = []
f = open('drugbank' + str(start) + '-' + str(end) +'.txt', 'a')
for i in range(start, end):
    url = generateURL(i)
    print(url)
    soup = get_page_content(url)
    try:
        jsonData = json.loads(str(soup))

        for item in range(0, len(jsonData)):
            medicine_name = jsonData[item]['tenThuoc']
            contain = jsonData[item]['hoatChat']
            list_contains = preprocessMedicineContain(contain)
        
        medicine_row = {
            'name': medicine_name,
            'contains': list_contains
        }

        medicine_list.append(medicine_row)
    
    except ValueError as e:
        print(e)
    # time.sleep(1)
   

medicine_json  = json.dumps(medicine_list, indent = 4)  
f.write(medicine_json)
f.close()