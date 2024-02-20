select ad_id,
ifnull(round(100 *sum(case when action = 'Clicked' then 1 else 0 end) 
/
sum(case when action = 'Clicked' or action = 'Viewed' then 1 else 0 end),2),0.00) as ctr
from Ads
group by 1
order by ctr desc, ad_id



-- Python
import pandas as pd

def ads_performance(ads: pd.DataFrame) -> pd.DataFrame:
    # Group by 'ad_id' and calculate the CTR for each group
    ctr = ads.groupby('ad_id')['action'].apply(
        lambda x: round(
            (sum(x == 'Clicked') / (sum(x == 'Clicked') + sum(x == 'Viewed')) * 100) if (sum(x == 'Clicked') + sum(x == 'Viewed')) > 0 else 0.00, 
            2
        )
    ).reset_index()

    # Rename the column to 'ctr'
    ctr.columns = ['ad_id', 'ctr']
    
    # Sort the results by 'ctr' in descending order and by 'ad_id' in ascending order
    result = ctr.sort_values(by=['ctr', 'ad_id'], ascending=[False, True])

    return result
