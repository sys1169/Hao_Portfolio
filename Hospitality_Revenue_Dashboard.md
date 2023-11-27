# Hospitality Revenue Dashboard (Power BI)
Case Study: Atliq Grands noticed a loss in their market share and revenue over a few months. To understand the causes, they need a way to analyze this. My job is to craete a interative dashboard for stakeholder and provide strategic recommendations to increase their revenue.

## Objective
i. To capture real-time crypto prices data, refresh every minute.  
ii. To visualize crypto price trend and understand current market sentiment.  
iii. To predict the bitcoin price in next 3 month as an indicator for investment.

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
