# To pull real time crypto data from https://coinmarketcap.com/ using API
url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
parameters = {
  'start':'1',
  'limit':'15',
  'convert':'USD'
}
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': '0ad53085-1cb2-4eb8-ad9e-3ffbd7e56509',
}

session = Session()
session.headers.update(headers)

try:
  response = session.get(url, params=parameters)
  data = json.loads(response.text)
  print(data)
except (ConnectionError, Timeout, TooManyRedirects) as e:
  print(e)

# Note:
# In case of reaching output limit, type: "jupyter notebook --NotebookApp.iopub_data_rate_limit=1e10"
# Into the Anaconda Prompt to change this to allow to pull data

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import plotly.express as px
import os
from time import time
from time import sleep

# Display all columns and rows
pd.set_option('display.max_columns',None)
pd.set_option('display.max_rows',15)

# Format numeric value to 5 decimals
pd.set_option('display.float_format', lambda x : '%.5f' % x)

# Normalizes data to dataframe
df = pd.json_normalize(data['data'])

# Input last_updated time
df['timestamp'] = pd.to_datetime('now').round('1min')
df


# Create a function that pull real time crypto data and store into CSV file every minute
def api_run():
    
    url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
    parameters = {
      'start':'1',
      'limit':'15',
      'convert':'USD'
    }
    headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': '6320bbe5-738e-433b-837b-5f47eec903b1',
    }

    session = Session()
    session.headers.update(headers)

    try:
      response = session.get(url, params=parameters)
      data = json.loads(response.text)
      #print(data)
    except (ConnectionError, Timeout, TooManyRedirects) as e:
      print(e)
    
    df = pd.json_normalize(data['data'])
    df['timestamp'] = pd.to_datetime('now').round('1min')
    
    if not os.path.isfile(r'D:\Data Analyst\Crytomarket.csv'):
        df.to_csv(r'D:\Data Analyst\Crytomarket.csv', header = 'column_name', index = False)
    else:
        df.to_csv(r'D:\Data Analyst\Crytomarket.csv', mode = 'a', header = False, index = False)


# Automate data pulling every 1 minute
count = 1
while True:
    api_run()
    print(f"API run completed ({count})")
    count += 1
    sleep(60)


# Visualized Top 15 cryptocurrency performance
df1 = pd.read_csv(r'D:\Data Analyst\Crytomarket.csv')
df1

# Group by 'name' and calculate the percent change for each time frame
df2 = df1.groupby('name',sort=False)[['quote.USD.percent_change_1h', 'quote.USD.percent_change_24h', 'quote.USD.percent_change_7d', 'quote.USD.percent_change_30d', 'quote.USD.percent_change_60d', 'quote.USD.percent_change_90d']].mean()
df2 = df2.reset_index()
df2

# Melt the DataFrame to transform it into long format
df3 = df2.melt(id_vars = 'name', var_name = 'time_frame', value_name = 'percent_change')
df3

# Rename the time_frame values
df3['time_frame'] = df3['time_frame'].replace({
    'quote.USD.percent_change_1h': '1h',
    'quote.USD.percent_change_24h': '24h',
    'quote.USD.percent_change_7d': '7d',
    'quote.USD.percent_change_30d': '30d',
    'quote.USD.percent_change_60d': '60d',
    'quote.USD.percent_change_90d': '90d'
})

# Create a point plot using Seaborn
sns.catplot(x = 'time_frame', y = 'percent_change', hue = 'name', data = df3, kind = 'point', aspect = 1.6)
plt.title('Cryptocurrency Price Changes Over Time')
plt.xlabel('')


# Visualized real-time Bitcoin price
# Select real time Bitcoin data and format it
df1 = pd.read_csv(r'D:\Data Analyst\Crytomarket.csv')
df_b = df1[['name', 'quote.USD.price', 'timestamp']]
df_b = df_b.query("name in ['Bitcoin']")
df_b = df_b.rename(columns = {'quote.USD.price':'USD'})
df_b['timestamp'] = pd.to_datetime(df_b['timestamp'])
df_b

# Plot Bitcoin price chart
fig = px.line (df_b, x = 'timestamp', y = 'USD', title = 'Bitcoin Prices', template = 'plotly_dark', color_discrete_sequence = ['orange'], width = 900)
fig.update_xaxes(title_text = '')
fig.update_layout(title_x = 0.5)
fig.update_layout
fig.show()

