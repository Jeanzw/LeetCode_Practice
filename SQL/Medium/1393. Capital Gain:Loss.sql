select stock_name,
sum(case when operation = 'Buy' then -price else price end) as capital_gain_loss from Stocks
group by stock_name


-- Python
import pandas as pd
import numpy as np

def capital_gainloss(stocks: pd.DataFrame) -> pd.DataFrame:
    stocks['capital'] = np.where(stocks['operation'] == 'Buy', -stocks['price'], stocks['price'])
    res = stocks.groupby('stock_name', as_index = False).capital.sum()

    return res.rename(columns = {'capital':'capital_gain_loss'})