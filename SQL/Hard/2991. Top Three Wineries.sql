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

-------------------------------

-- Python
import pandas as pd

def top_three_wineries(wineries: pd.DataFrame) -> pd.DataFrame:
-- 先求和
    wineries = wineries.groupby(['country','winery'],as_index = False).points.sum()
-- 再排序
    wineries.sort_values(['points','winery'], ascending = [0,1])
-- 给个序列
    wineries['rnk'] = wineries.groupby(['country']).points.rank(method = 'first',ascending = False)
-- 将名字+分数进行数据处理
    wineries['name_point'] = wineries['winery'] + ' (' + wineries['points'].astype(str) + ')'

    first = wineries[wineries['rnk'] == 1][['country','name_point']]
    second = wineries[wineries['rnk'] == 2][['country','name_point']]
    third = wineries[wineries['rnk'] == 3][['country','name_point']]

    merge = pd.merge(first,second, on = 'country',how = 'left').fillna('No second winery')
    merge = pd.merge(merge,third,on = 'country',how = 'left').fillna('No third winery')
    return merge.rename(columns = {'name_point_x':'top_winery','name_point_y':'second_winery','name_point':'third_winery'}).sort_values('country')