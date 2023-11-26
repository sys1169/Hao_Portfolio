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
![bitcoim](https://github.com/sys1169/Hao_Portfolio/assets/59571707/a3704108-6fb2-46e7-9851-aecc89a73816)
