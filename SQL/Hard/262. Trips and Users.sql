-- 知识点：
-- 1. 保留几位小数round(xxx,2)
select
    Request_at as Day,
    round(count(distinct case when Status != 'completed' then Id else null end)
    /
    count(distinct Id),2) as 'Cancellation Rate'
from Trips t
join Users u1 on t.Client_Id = u1.Users_Id and u1.Banned = 'No' 
join Users u2 on t.Driver_Id = u2.Users_Id and u2.Banned = 'No' 
where Request_at between "2013-10-01" and "2013-10-03"
group by 1

---------------------------

-- 其实也可以不用join来筛选unbanned的内容，直接用where和not in来进行筛选
-- 下面是我后来写的
select Request_at as Day,
ifnull(round(sum(case when Status != 'completed' then 1 else 0 end)/count(*),2),0.00) as 'Cancellation Rate'
from Trips

where Client_Id in (select Users_Id from Users where Banned != 'Yes')
and Driver_Id in (select Users_Id from Users where Banned != 'Yes')
and Request_at BETWEEN '2013-10-01' AND '2013-10-03'

group by Request_at

-- 这里我们需要注意的是一定要是case when Status != 'completed' then 1 else 0 end，因为calcelled by可以是client也可以是driver，如果用calcelled那么就会比较麻烦

---------------------------

-- 下面我开始用cte来写，逻辑感觉比较清楚
with ban as
(select Users_Id from Users where Banned = 'Yes')
-- 上面这个ban就是把已经被限制的userid给取出来
, eligible_case as
(select * from Trips
where Client_Id not in (select Users_Id from ban)
 and Driver_Id not in (select Users_Id from ban)
 and Request_at between '2013-10-01' and '2013-10-03'
)
-- eligible case找出符合要求的数据

select 
Request_at as Day,
round(sum(case when Status != 'completed' then 1 else 0 end)/count(*),2) as 'Cancellation Rate'
from eligible_case

---------------------------

-- 再一次写的时候逻辑更清楚一点，我不太想要用not in
-- 先用一个cte把banned的行都给剔除掉
with unbanned as
(select 
a.*
from Trips a
left join Users b on b.banned = 'Yes' and (a.client_id = b.users_id or a.driver_id = b.users_id)
where b.users_id is null
)

-- 然后就可以直接进行计算了
select 
request_at as Day,
round(count(distinct case when status != 'completed' then id end ) 
/
count(distinct id),2) as "Cancellation Rate"
from unbanned
where request_at between '2013-10-01' and '2013-10-03'
group by 1
order by 1

---------------------------

-- Python
import pandas as pd
import numpy as np

def trips_and_users(trips: pd.DataFrame, users: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(trips,users,left_on = 'client_id', right_on = 'users_id').merge(users, left_on = 'driver_id', right_on = 'users_id')
    merge = merge[(merge['banned_x'] == 'No') & (merge['banned_y'] == 'No') & (merge['request_at'] >= '2013-10-01') & (merge['request_at'] <= '2013-10-03')]

    merge['cancel'] = np.where(merge['status'] != 'completed', merge['id'], None)

    merge = merge.groupby(['request_at'],as_index = False).agg(
        n = ('cancel','nunique'),
        d = ('id','nunique')
    )
    merge['Cancellation Rate'] = round(merge['n']/merge['d'],2)
    return merge[['request_at','Cancellation Rate']].rename(columns = {'request_at':'Day'})

--------------------

-- 其实也可以先把表格在最开始处理一下
import pandas as pd
import numpy as np

def trips_and_users(trips: pd.DataFrame, users: pd.DataFrame) -> pd.DataFrame:
    unbanned_user = users[users['banned'] == 'No']
    trips = trips[(trips['request_at'] >= '2013-10-01') & (trips['request_at'] <= '2013-10-03')]
    merge = pd.merge(trips,unbanned_user,left_on = 'client_id', right_on = 'users_id').merge(unbanned_user,left_on = 'driver_id', right_on = 'users_id')
    merge['cancel_id'] = np.where(merge['status'] != 'completed', merge['id'], None)
    merge = merge.groupby(['request_at'],as_index = False).agg(
        n = ('cancel_id','nunique'),
        d = ('id','nunique')
    )
    merge['Cancellation Rate'] = round(merge['n']/merge['d'],2)
    return merge[['request_at','Cancellation Rate']].rename(columns = {'request_at':'Day'})