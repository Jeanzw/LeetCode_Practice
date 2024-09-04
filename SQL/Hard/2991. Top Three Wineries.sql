with cte as
(select
country, winery,sum(points) as points, row_number() over (partition by country order by sum(points) desc, winery) as rnk
from Wineries
group by 1,2)

select
country,
-- 我们下面是先max之后，然后判断是否是null值，如果是null值再赋予其一个新的替代值
ifnull(max(case when rnk = 1 then concat(winery,' (',points,')') end),'No first winery') as top_winery,
ifnull(max(case when rnk = 2 then concat(winery,' (',points,')') end),'No second winery') as second_winery,
ifnull(max(case when rnk = 3 then concat(winery,' (',points,')') end),'No third winery') as third_winery
from cte 
group by 1
order by 1


-- Python
import pandas as pd

def top_three_wineries(wineries: pd.DataFrame) -> pd.DataFrame:
    # 1. get agg points
    wineries = wineries.groupby(['country', 'winery']).agg(
        ttl_points = ('points', 'sum')
    ).reset_index()
    # 2. sort and rank
    wineries = wineries.sort_values(by = ['country', 'ttl_points', 'winery'], ascending = [1, 0, 1])
    wineries['rnk'] = wineries.groupby('country')['ttl_points'].rank(ascending=False, method='first') # method = 'first' is used to order wineries by winery name in ascending order if they have same points
    # 3. get concat winery_points
    wineries['winery_points'] = wineries['winery'] + ' (' + wineries['ttl_points'].astype(str) + ')'
    # 4. get unique countries
    df = pd.DataFrame(data = wineries['country'].unique(), columns = ['country'])
    # 5. merge and get top second and third columns
    df = df.merge(wineries[wineries['rnk'] == 1][['country', 'winery_points']], how = 'left', on = 'country').rename(columns = {'winery_points':'top_winery'})
    df = df.merge(wineries[wineries['rnk'] == 2][['country', 'winery_points']], how = 'left', on = 'country').rename(columns = {'winery_points':'second_winery'}).fillna('No second winery')
    df = df.merge(wineries[wineries['rnk'] == 3][['country', 'winery_points']], how = 'left', on = 'country').rename(columns = {'winery_points':'third_winery'}).fillna('No third winery')
    # 6. sort and return
    return df.sort_values(by = 'country', ascending = True)