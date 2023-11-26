# Forecast Bitcoin price movement using the FbProphet model and ARIMA model
import yfinance as yf
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math
import statsmodels.api as sm
from prophet import Prophet
import pmdarima as pmd
from pmdarima.model_selection import train_test_split

# Bitcoin data preparation
# Download Bitcoin data
btc_df = yf.download('BTC-USD')
btc_df

# Extract BTC prices since the launch of the first US BTC ETF
btc = btc_df['Adj Close']['2021-10-19':'2023-11-24']

# Explore BTC data information
btc.info()
btc.describe()

# Plot BTC prices
btc.plot(figsize=(15,6))
plt.show()

# Time series decomposition
decomposition = sm.tsa.seasonal_decompose(btc, model='additive')
fig = decomposition.plot()
plt.show()


# 1) Facebook Prophet for Bitcoin Price Prediction
# Select data and data cleaning
btc_d = btc_df['Adj Close']['2021-10-19':'2023-11-24'].reset_index()
btc_d.columns = ['ds', 'y']
btc_d

# Prophet model fitting
pm = Prophet(interval_width=0.95)
pm.fit(btc_d)

# Get forecast 100 days ahead in future
future = pm.make_future_dataframe(periods=100, freq='d')
forecast = pm.predict(future)

# Display forecasted values
forecast[['ds','yhat']]

# MAPE
y_true = btc_d['y']
y_pred = forecast['yhat'][:len(y_true)]
mape = np.mean(np.abs((y_true - y_pred) / y_true)) * 100
print(f'MAPE: {mape:.2f}%')

# Plot forecast and components
plot_f = pm.plot(forecast)
plot_c = pm.plot_components(forecast)
plt.show()


# 2) SARIMA for Bitcoin Price Prediction
# Select data
btc_d2 = btc_df['Adj Close']['2021-10-19':'2023-11-24']
btc_d2

# Train-test split for time series data
train, test = train_test_split(btc_d2, train_size=0.8)

# Auto ARIMA model selection
Auto_ARIMA_model = pmd.auto_arima(train, start_p=1, start_q=1, max_p=3, max_q=3, m=12,
                      start_P=0, seasonal=True, d=1, D=1, trace=True,
                      error_action='ignore', suppress_warnings=True, stepwise=True)

# SARIMA model fitting
s_model = sm.tsa.statespace.SARIMAX(btc_d2,
                                order=(0, 1, 2),
                                seasonal_order=(1, 1, 1, 12),
                                enforce_stationarity=False,
                                enforce_invertibility=False)

results = s_model.fit()
results.summary().tables[1]

# Plot model diagnostics
results.plot_diagnostics(figsize=(15, 12))
plt.show()

# Make predictions
pred = results.get_prediction(start=pd.to_datetime('2023-8-24'), dynamic=False)
pred_ci = pred.conf_int()

# MAPE
y_true = btc_d2['2023-8-24':]
y_pred = pred.predicted_mean
mape = np.mean(np.abs((y_true - y_pred) / y_true)) * 100
print(f'MAPE: {mape:.2f}%')

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
