select
    date_id,
    make_name,
    count(distinct lead_id) as unique_leads,
    count(distinct partner_id) as unique_partners
    from DailySales
    group by 1,2

---------------------------------

-- Python
import pandas as pd

def daily_leads_and_partners(daily_sales: pd.DataFrame) -> pd.DataFrame:
    res = daily_sales.groupby(['date_id','make_name'], as_index = False).agg(
    unique_leads = ('lead_id','nunique'),
    unique_partners = ('partner_id','nunique')
)
    return res