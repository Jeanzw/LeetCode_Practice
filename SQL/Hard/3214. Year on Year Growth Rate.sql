with cal_summary as
(select
year(transaction_date) as year,
product_id,
sum(spend) as curr_year_spend
from user_transactions
group by 1,2
)

select
a.year,
a.product_id,
a.curr_year_spend,
b.curr_year_spend as prev_year_spend,
round(100 * (a.curr_year_spend - b.curr_year_spend)/b.curr_year_spend,2) as yoy_rate
from cal_summary a
left join cal_summary b on a.year - 1 = b.year and a.product_id = b.product_id
order by 2,1


-- Python
import pandas as pd
import numpy as np

def calculate_yoy_growth(user_transactions: pd.DataFrame) -> pd.DataFrame:
    user_transactions['year'] = user_transactions.transaction_date.dt.year
    summary = user_transactions.groupby(['year','product_id'], as_index = False).spend.sum()
    summary = pd.merge(summary,summary,on = 'product_id', how = 'left')
    summary['rnk'] = summary.groupby(['product_id']).year_x.rank(method = 'first')
    summary = summary.query("year_x - 1 == year_y or rnk == 1")
    summary['spend_y'] = np.where(summary['rnk'] == 1, None, summary['spend_y'])
    summary['yoy_rate'] = round(((summary['spend_x'] - summary['spend_y'])/summary['spend_y']) * 100,2)
    return summary[['year_x','product_id','spend_x','spend_y','yoy_rate']].rename(columns = {'year_x':'year','spend_x':'curr_year_spend','spend_y':'prev_year_spend'}).sort_values(['product_id','year'])