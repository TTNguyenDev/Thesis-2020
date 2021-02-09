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

print(df.columns)
print(df.head(5))
print(df.tail(5))

df['noSpace'].to_csv(r'noSpace.txt', header=None, index=None, sep='\n', mode='a')