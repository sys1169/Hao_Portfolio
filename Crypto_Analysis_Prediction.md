# Real-Time Crypto Analysis and Prediction (Python)
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

![11](https://github.com/sys1169/Hao_Portfolio/assets/59571707/a7ac69ea-8bad-47ca-b90d-743204944a81)

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

![222](https://github.com/sys1169/Hao_Portfolio/assets/59571707/6a83c7f7-5235-44fc-ae85-b62bacf988be)

Result: The chart illustrates an uptrend for all cryptocurrencies over the past 30/60/90 days, a prolonged uptrend often reflects positive market sentiment. Investors may be optimistic about the future of cryptocurrencies, leading to increased demand and rising prices, indicating potential investment opportunities.

## 3a. Forecast Bitcoin price using FbProphet
The Facebook Prophet is an open-source forecasting tool designed for time series forecasting, is specifically designed to handle time series data with strong seasonality and multiple seasonality components.  

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

Result: The decomposition chart suggests a seasonal effect influencing the fluctuations in Bitcoin prices. The spreading residuals observed indicate the presence of non-constant variance, implying that our predictive models may be subject to some degree of bias. 

<details>
<summary>Prophet model</summary>

```
# Prophet model fitting
pm = Prophet(interval_width=0.95)
pm.fit(btc_d)

# Get forecast 100 days ahead in future
future = pm.make_future_dataframe(periods=100, freq='d')
forecast = pm.predict(future)

plot_f = pm.plot(forecast)
plot_c = pm.plot_components(forecast)
plt.show()
```
</details>

<details>
<summary>Mean absolute percentage error(MAPE)</summary>

```
y_true = btc_d['y']
y_pred = forecast['yhat'][:len(y_true)]
mape = np.mean(np.abs((y_true - y_pred) / y_true)) * 100
print(f'MAPE: {mape:.2f}%')
```
</details>

MAPE: 5.20%<10%, the model demonstrates a high level of accuracy.  
  
Bitcoin price prediction:

![qsda](https://github.com/sys1169/Hao_Portfolio/assets/59571707/3fbd07ef-5ede-44de-b7d4-bcd9718c6d28)

Result: The Prophet model predicts that Bitcoin's price growth might slow down in the next month, but it's expected to go up again in the following two months.   

Bitcoin trend components:

![asdfsa](https://github.com/sys1169/Hao_Portfolio/assets/59571707/52bbc22d-4572-4fe0-8ef1-64dbda542da4)

Result: The trends component indicates a robust upward trajectory for Bitcoin starting from April 2023. Additionally, Bitcoin tends to perform well during the early weekdays (Monday to Wednesday) on a weekly basis. In a broader context, it shows stronger performance from February to June throughout the years.

## 3a. Forecast Bitcoin price using SARIMA
The SARIMA is a widely used traditional time series forecasting method. The model takes into account the autoregressive relationship, differencing, and moving average components to forecast future values.

<details>
<summary>Train-test data split</summary>

```
# Select data
btc_d2 = btc_df['Adj Close']['2021-10-19':'2023-11-24']

# Train-test split for time series data
train, test = train_test_split(btc_d2, train_size=0.8)
```
</details>

<details>
<summary>Auto ARIMA model selection</summary>

```
Auto_ARIMA_model = pmd.auto_arima(train, start_p=1, start_q=1, max_p=3, max_q=3, m=12,
                      start_P=0, seasonal=True, d=1, D=1, trace=True,
                      error_action='ignore', suppress_warnings=True, stepwise=True)
```
</details>

<details>
<summary>SARIMA model</summary>

```
s_model = sm.tsa.statespace.SARIMAX(btc_d2,
                                order=(0, 1, 2),
                                seasonal_order=(1, 1, 1, 12),
                                enforce_stationarity=False,
                                enforce_invertibility=False)

results = s_model.fit()
results.summary().tables[1]
```
</details>

<details>
<summary>Model diagnostics</summary>

```
results.plot_diagnostics(figsize=(15, 12))
plt.show()
```
</details>

![gwed](https://github.com/sys1169/Hao_Portfolio/assets/59571707/1c053746-cca3-4f2e-821c-2c4bcb64e8a2)

<details>
<summary>Backtesting using "One-step ahead Forecast"</summary>

```
# Make predictions
pred = results.get_prediction(start=pd.to_datetime('2023-8-24'), dynamic=False)
pred_ci = pred.conf_int()

# Plot observed vs predicted
ax = btc_d2['2022':].plot(label='Observed')
pred.predicted_mean.plot(ax=ax, label='One-step ahead Forecast', alpha=.7)

ax.fill_between(pred_ci.index,
                pred_ci.iloc[:, 0],
                pred_ci.iloc[:, 1], color='k', alpha=.1)

ax.set_xlabel('Date')
ax.set_ylabel('USD')
plt.title('Bitcoin Prices "One-step ahead Forecast"')
plt.legend()

plt.show()
```
</details>

<details>
<summary>Mean absolute percentage error(MAPE)</summary>

```
y_true = btc_d2['2023-8-24':]
y_pred = pred.predicted_mean
mape = np.mean(np.abs((y_true - y_pred) / y_true)) * 100
print(f'MAPE: {mape:.2f}%')
```
</details>

MAPE: 1.48%<10%, the model demonstrates a high level of accuracy.  

![zasd](https://github.com/sys1169/Hao_Portfolio/assets/59571707/dab4f979-492c-49d7-aa4e-bd4f77868deb)

Result: During the backtesting, the 'One-step ahead Forecast' demonstrates a strong fit with the actual Bitcoin price movement.

<details>
<summary>Bitcoin price forecast</summary>

```
# Get forecast 100 days ahead in future
fore = results.get_forecast(steps=100)

# Get confidence intervals of forecasts
fore_ci = fore.conf_int()

# Plot forecast
ax = btc_d2.plot(label='Observed')
fore.predicted_mean.plot(ax=ax, label='Forecast')

ax.fill_between(fore_ci.index,
                fore_ci.iloc[:, 0],
                fore_ci.iloc[:, 1], color='k', alpha=.1)

ax.set_xlabel('Date')
ax.set_ylabel('USD')
plt.title('Bitcoin Prices Forecast')
plt.legend()

plt.show()
```
</details>

![arcs](https://github.com/sys1169/Hao_Portfolio/assets/59571707/e0bdddb2-21e4-429d-b9d8-b930356a69ab)

Result: According to our SARIMA model, it looks like Bitcoin prices are on the rise in the next three months shown by the rising orange line. The grey area around it reflects a 95% confidence interval, meaning there are 95% the actual prices will fall somewhere in there.

## Summary
In sum, I imported real-time data using CoinMarket's API, analyze current crypto market trend, visualized my data, decomposed Bitcoin prices, and ran two prediction models — FBProphet and SARIMA. I found that (1) crypto has been on a prolonged uptrend since April 2023, reflecting optimistic and positive market sentiment, (2) Bitcoin prices tend to perform better from Monday to Wednesday, as well as from February to June, and (3)  both models predict an upward movement in Bitcoin prices over the next three months.

What I would like to do next is utilize more prediction model! I would also like to explore more about the relationship between cryptocurrency and macroeconomic variable using regression model.

