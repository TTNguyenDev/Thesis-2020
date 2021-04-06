import pandas as pd
from pandas.io.json import json_normalize
import numpy as np
import warnings
import re
warnings.filterwarnings("ignore")

data_path = 'PreProcessData.json'
weights = ['mg', 'ml', '%']

def readJsonFile(path):
    df = pd.read_json(path, orient='records')
    return df



df = readJsonFile(data_path)
# del df['name']
df.dropna(subset = ["shortname"], inplace=True)
print(df.columns)
print(df.tail(5))

short_name = df[df.columns[3]].tolist()
contains = df[df.columns[1]].tolist()

print(short_name)
# df.to_json(r'PreProcessData.json')
