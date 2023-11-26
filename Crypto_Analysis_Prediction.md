# Real-Time Crypto Data Analysis and Prediction (Python)
As someone diving into the crypto world with a genuine interest, this project is about exploring beyond the usual analyses, uncovering real-time insights and predicting trends that aren't readily available through standard tools.

## Objective
i. To capture real-time crypto prices data, refresh every minute  
ii. To visualize price trend of top 15 cryptocurrency in past 90 days  
iii. To predict the bitcoin price in next 3 months  

## 1. Set up real-time Crypto Data
url = https://coinmarketcap.com/api/  
Get the API key and apply it into 'Start code' given by the website
<details>
<summary>Create a function that pull real time crypto data and store into CSV file</summary>
  
```
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
```
</details>
<details>
<summary>Automate data pulling every one minute</summary>

```
count = 1
while True:
    api_run()
    print(f"API run completed ({count})")
    count += 1
    sleep(60)
```
</details>
<details>
<summary>Visualize real-time Bitcoin price</summary>

```
df1 = pd.read_csv(r'D:\Data Analyst\Crytomarket.csv')
df_b = df1[['name', 'quote.USD.price', 'timestamp']]
df_b = df_b.query("name in ['Bitcoin']")
df_b = df_b.rename(columns = {'quote.USD.price':'USD'})
df_b['timestamp'] = pd.to_datetime(df_b['timestamp'])

fig = px.line (df_b, x = 'timestamp', y = 'USD', title = 'Bitcoin Prices', template = 'plotly_dark', color_discrete_sequence = ['orange'], width = 900)
fig.update_xaxes(title_text = '')
fig.update_layout(title_x = 0.5)
fig.update_layout
fig.show()
```
</details>

![bitcoim](https://github.com/sys1169/Hao_Portfolio/assets/59571707/8e3a9878-e369-4ac1-90cf-9958c5259535)

## 2. Visualize price trend of top 15 cryptocurrency
Using the data from section 1.
<details>
<summary>Data preparation</summary>

```
# Group by 'name' and calculate the percent change for each time frame
df2 = df1.groupby('name',sort=False)[['quote.USD.percent_change_1h', 'quote.USD.percent_change_24h', 'quote.USD.percent_change_7d', 'quote.USD.percent_change_30d', 'quote.USD.percent_change_60d', 'quote.USD.percent_change_90d']].mean()
df2 = df2.reset_index()

# Melt the DataFrame to transform it into long format
df3 = df2.melt(id_vars = 'name', var_name = 'time_frame', value_name = 'percent_change')

# Rename the time_frame values
df3['time_frame'] = df3['time_frame'].replace({
    'quote.USD.percent_change_1h': '1h',
    'quote.USD.percent_change_24h': '24h',
    'quote.USD.percent_change_7d': '7d',
    'quote.USD.percent_change_30d': '30d',
    'quote.USD.percent_change_60d': '60d',
    'quote.USD.percent_change_90d': '90d'
})
```
</details>
<details>
<summary>Create a point plot using Seaborn</summary>

```
sns.catplot(x = 'time_frame', y = 'percent_change', hue = 'name', data = df3, kind = 'point', aspect = 1.6)
plt.title('Cryptocurrency Price Changes Over Time')
plt.xlabel('')
```
</details>

![crypto](https://github.com/sys1169/Hao_Portfolio/assets/59571707/6da80bc5-3b25-4b42-b01d-08b0a096f40b)
The chart illustrates an uptrend for all cryptocurrencies over the past 90 days, showing great investment opportunities.

## 3a. Forecast Bitcoin price using FbProphet
To enhance the accuracy of predictions, I utilize data from the inception of the US BTC ETF on October 19, 2021, to forecast the Bitcoin price. This allows the model to account for the sentiment changes that might have accompanied with the event.

<details>
<summary>Data preparation</summary>

```
# Download Bitcoin data
btc_df = yf.download('BTC-USD')

# Extract BTC prices since the launch of the first US BTC ETF
btc = btc_df['Adj Close']['2021-10-19':'2023-11-24']

# Explore BTC data information
btc.info()
btc.describe()
```
</details>

<details>
<summary>Bitcoin price decomposition from 2021-10-19 to 2023-11-24</summary>

```
decomposition = sm.tsa.seasonal_decompose(btc, model='additive')
fig = decomposition.plot()
plt.show()
```
</details>

![qweq](https://github.com/sys1169/Hao_Portfolio/assets/59571707/aa7ce9b5-a094-457a-8d96-aedd5d3ba0c4)

The seasonal effect on Bitcoin prices has been identified, and the spreading residuals indicate a nonconstant variance.
