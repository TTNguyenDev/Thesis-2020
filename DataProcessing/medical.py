import pandas as pd
from pandas.io.json import json_normalize
import numpy as np
import warnings
import re
warnings.filterwarnings("ignore")

data_path = '/Users/trietnguyen/Documents/Thesis/Thesis-2020/References/Crawler/summaryDataJson.json'

weights = ['mg', 'ml', '%']

def formatName(name):
    arr = re.split(' |-', name)
    print(arr) 
    gweight = ''
    gname = [] 
    gnumber = ''
    for word in arr:
        if any(str.isdigit(c) for c in word): #2 trường hợp 200 200mg
            for weight in weights:
                pos = word.find(weight)
                if pos != -1:
                    gweight = weight       
                    gnumber = word[:pos]
                    break
                else:
                    gnumber = word
        
        elif any(word == weight for weight in weights):
            gweight = word
        elif word != '':
            gname.append(word)

    return (gnumber, gweight ,' '.join(gname))

def cleanName(name):
    return re.sub(r'[^a-z0-9]', '', name.lower()) 

def rmSpecialCharacters(df):
    df['noSpace'] = df['noSpace'].apply(cleanName)
     
def rmDuplicate(df):
    df.drop_duplicates(subset ='noSpace', 
                     keep = 'first', inplace = True)
    df.index = range(len(df.index))

def splitMedicine(df):
    df_temp = df['name'].apply(formatName) 
    new_df = pd.DataFrame([[a, b, c] for a,b,c in df_temp.values], columns=['number', 'weight', 'short name'])
    return new_df 

#Read data
df = pd.read_json(data_path, orient='records')

df.drop_duplicates(subset ="name", 
                     keep = 'first', inplace = True)
df.index = range(len(df.index))

#Xoá các thuốc có tiếng việt
nonTiengViet_df = df.loc[df['name'].str.contains(r'[^\x00-\x7F]+') == False]
#print(nonTiengViet_df.head(10))

#Remove duplicate bằng cách xoá hết các khoảng trắng của tên thuốc, nếu trùng tên và thành phần thì xoá 
nonTiengViet_df['noSpace'] = nonTiengViet_df.name 
rm_character = ['-', '\"', '/', ' ', ',', '.']
rmSpecialCharacters(nonTiengViet_df)

rmDuplicate(nonTiengViet_df)

# sort dataframe:
nonTiengViet_df = nonTiengViet_df.sort_values(by=['noSpace'], ascending=True)
nonTiengViet_df.index = range(len(nonTiengViet_df.index))
# split thuốc theo [' ', '-']
# Tìm các từ có tồn tại số 200, 200mg, 0.1mg/ml 150 ....
# 
print(formatName('10mg  Dextrose in Water Parenteral Solution for ..'))
splitMedicine(nonTiengViet_df)

new_df = splitMedicine(nonTiengViet_df)
nonTiengViet_df['shortname'] = new_df['short name']
nonTiengViet_df['number'] = new_df['number']
nonTiengViet_df['weight'] = new_df['weight']


nonTiengViet_df['noSpace'] = nonTiengViet_df.shortname 
rm_character = ['-', '\"', '/', ' ', ',', '.']
rmSpecialCharacters(nonTiengViet_df)

rmDuplicate(nonTiengViet_df)

print(nonTiengViet_df.describe)
print(nonTiengViet_df.tail(5))
nonTiengViet_df.to_json(r'PreProcessData.json')

