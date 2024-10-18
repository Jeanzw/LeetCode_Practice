select stock_name,
sum(case when operation = 'Buy' then -price else price end) as capital_gain_loss from Stocks
group by stock_name


-- Python
import pandas as pd
import numpy as np

def capital_gainloss(stocks: pd.DataFrame) -> pd.DataFrame:
-- 直接在建列的时候起好名字
    stocks['capital_gain_loss'] = np.where(stocks['operation'] == 'Buy', -stocks['price'], stocks['price'])
    stocks = stocks.groupby(['stock_name'],as_index = False).capital_gain_loss.sum()
    return stocks
    