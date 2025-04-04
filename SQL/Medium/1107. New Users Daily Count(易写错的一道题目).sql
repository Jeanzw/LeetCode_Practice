select min(activity_date) as login_date,count(distinct user_id) as user_count from Traffic
where (user_id,activity_date) in 
(select user_id,min(activity_date) from Traffic
where activity = 'login'  --这一个条件需要注意，我经常会忽略掉
group by user_id
having datediff('2019-06-30',MIN(activity_date))<=90)
group by activity_date

---------------------

-- 上面这种我们可以写成这样的
select
activity_date as login_date,
count(distinct user_id) as user_count
from Traffic
where datediff('2019-06-30',activity_date) <= 90
and activity = 'login'
and (user_id, activity_date) in (select user_id, min(activity_date) from Traffic where activity = 'login' group by 1 )
-- 有一个in来进行筛选，筛选掉最小值在这个过程中的
group by 1

---------------------

/*
由于我们要求的是最小的时间，所以一定要用where来作为指引
*/

--下面是我第二次写的答案，我们在where里面已经做了min（date）的筛选了
select activity_date as login_date, count(distinct user_id) as user_count from Traffic 
where (user_id,activity_date) in
(
select user_id, min(activity_date) as min_log from Traffic
    where activity = 'login'
group by 1
    having min_log  >= '2019-04-01'
)
group by 1

---------------------

-- 下面是新做的答案：
-- 我们不用In来解题，直接划定范围，然后开始计数
select first_login as login_date, count(distinct user_id) as user_count from
(select user_id,min(activity_date) as first_login from Traffic
where activity = 'login'
group by 1
having datediff('2019-06-30',min(activity_date)) <= 90)tmp
group by 1

---------------------

-- 我们也可以把时间范围放到最后一步
with cte as
(select
user_id, min(activity_date) as first_log
from Traffic
where activity = 'login'
group by 1)

select first_log as login_date, count(distinct user_id) as user_count
from cte
where datediff('2019-06-30',first_log) between 0 and 90
group by 1

---------------------

-- Python
import pandas as pd
import numpy as np
def new_users_daily_count(traffic: pd.DataFrame) -> pd.DataFrame:
    traffic = traffic.query("activity == 'login'").groupby(['user_id'],as_index = False).activity_date.min()
    traffic['flg'] = np.where((traffic['activity_date'] <= '2019-06-30') & (traffic['activity_date'] >= (pd.to_datetime('2019-06-30') - pd.to_timedelta(90,unit = 'd'))),1,0)
    traffic = traffic.query("flg == 1").groupby(['activity_date'],as_index = False).user_id.nunique()
    
    return traffic.rename(columns = {'activity_date':'login_date','user_id':'user_count'})

---------------------

-- 也可以这么做
import pandas as pd

def new_users_daily_count(traffic: pd.DataFrame) -> pd.DataFrame:
    traffic = traffic[traffic['activity'] == 'login']
    traffic = traffic.groupby(['user_id'],as_index = False).activity_date.min()
    traffic = traffic[(pd.to_datetime('2019-06-30') - traffic['activity_date']).dt.days <=90]
    traffic = traffic.groupby(['activity_date'],as_index = False).user_id.nunique()
    return traffic[['activity_date','user_id']].rename(columns = {'activity_date':'login_date','user_id':'user_count'})