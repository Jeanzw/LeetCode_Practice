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


-- 自己写的python
import pandas as pd
import numpy as np

def ads_performance(ads: pd.DataFrame) -> pd.DataFrame:
    ads['point'] = np.where(ads['action'] != 'Ignored', 1, 0)
    -- 我们下面对分子分母分别进行group by，然后再left join起来，这种方式太傻了
    num = ads.query("action == 'Clicked'").groupby(['ad_id'],as_index = False).point.sum()
    den = ads.groupby(['ad_id'],as_index = False).point.sum()
    res = pd.merge(num,den, on = 'ad_id', how = 'right')

    res['ctr'] = ((100 * res['point_x']/res['point_y']).fillna(0)).round(2)
    # (100 * np.where(res['point_y'] != 0,res['point_x']/res['point_y'],0)).round(2)
    return res[['ad_id','ctr']].sort_values(['ctr','ad_id'],ascending = [False, True])


-- 更高效的方式
import pandas as pd
import numpy as np

def ads_performance(ads: pd.DataFrame) -> pd.DataFrame:
    ads['clicked'] = np.where(ads['action'] == 'Clicked', 1, 0)
    ads['viewed'] = np.where(ads['action'] != 'Ignored', 1, 0)
-- 我们在group by的时候，如果有指定列，那么对指定列进行处理，如果没有指定列，那么对所有列进行处理
-- 通过下面的方式，我们就不用像上面那种解法一样，先求分子分母然后left join合并
    summary = ads[['ad_id','clicked','viewed']].groupby(['ad_id'], as_index = False).sum()

    summary['ctr'] = ((100 * summary['clicked']/summary['viewed']).fillna(0)).round(2)
    return summary[['ad_id','ctr']].sort_values(['ctr','ad_id'], ascending = [False, True])