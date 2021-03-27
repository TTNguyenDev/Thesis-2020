import pandas as pd

medicinePath =  'main_dict/high_res.csv'
df = pd.read_csv(medicinePath, sep=';', quotechar="\"", header=0)

print(df['info'])