select
(week(purchase_date) - week('2023-11-01') + 1) as week_of_month,
purchase_date,
sum(amount_spend) as total_amount
from Purchases
where month(purchase_date) = 11 and year(purchase_date) = 2023
and weekday(purchase_date) = 4
group by 1,2
order by 1


-- Python
import pandas as pd

def friday_purchases(purchases: pd.DataFrame) -> pd.DataFrame:
    purchases = purchases[(purchases['purchase_date'].dt.year == 2023) & (purchases['purchase_date'].dt.month == 11) & (purchases['purchase_date'].dt.weekday == 4)]
    purchases = purchases.groupby(['purchase_date'],as_index = False).amount_spend.sum()
    purchases['week_of_month'] = round(purchases['purchase_date'].dt.day/7+1)
    return purchases[['week_of_month','purchase_date','amount_spend']].rename(columns = {'amount_spend':'total_amount'}).sort_values('week_of_month')