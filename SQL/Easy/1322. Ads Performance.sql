select ad_id,
ifnull(round(100 *sum(case when action = 'Clicked' then 1 else 0 end) 
/
sum(case when action = 'Clicked' or action = 'Viewed' then 1 else 0 end),2),0.00) as ctr
from Ads
group by 1
order by ctr desc, ad_id

--------------------------------------

-- 我不是很喜欢用sum来做计数
select
ad_id,
round(ifnull(100 * count(case when action = 'Clicked' then ad_id end)
/
count(case when action in ('Clicked','Viewed') then ad_id end),0),2) as ctr
from Ads
group by 1
order by 2 desc, 1

--------------------------------------

-- Python
import pandas as pd
import numpy as np

def ads_performance(ads: pd.DataFrame) -> pd.DataFrame:
    ads['clicked'] = np.where(ads['action'] == 'Clicked', 1, 0)
    ads['viewed'] = np.where(ads['action'] != 'Ignored', 1, 0)
-- 我们在group by的时候，如果有指定列，那么对指定列进行处理，如果没有指定列，那么对所有列进行处理
    summary = ads[['ad_id','clicked','viewed']].groupby(['ad_id'], as_index = False).sum()

    summary['ctr'] = ((100 * summary['clicked']/summary['viewed']).fillna(0)).round(2)
    return summary[['ad_id','ctr']].sort_values(['ctr','ad_id'], ascending = [False, True])


-- 第二次做
import pandas as pd
import numpy as np

def ads_performance(ads: pd.DataFrame) -> pd.DataFrame:
    ads['d'] = np.where(ads['action'].isin(['Clicked','Viewed']), 1,0)
    ads['n'] = np.where(ads['action']== 'Clicked', 1,0)
    ads = ads.groupby(['ad_id'],as_index = False).agg(
        d = ('d','sum'),
        n = ('n','sum')
    )
    ads['ctr'] = round(100 * ads['n']/ads['d'],2).fillna(0)
        
    return ads[['ad_id','ctr']].sort_values(['ctr','ad_id'],ascending = [0,1])