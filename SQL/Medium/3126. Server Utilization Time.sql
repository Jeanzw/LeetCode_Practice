with cte as
(select
server_id,
status_time,
session_status,
lead(status_time,1) over (partition by server_id order by status_time, session_status) as next_line
from Servers)

select floor(sum(timestampdiff(second,status_time,next_line)/86400)) as total_uptime_days 
from cte 
where next_line is not null 
and session_status = 'start'

--------------------------

-- 也可以这么做：
with cte as
(select
server_id, status_time,session_status,row_number() over (partition by server_id,session_status order by status_time) as rnk
from Servers)

select 
floor(sum(timestampdiff(second,a.status_time, b.status_time))/(60 * 60 * 24)) as total_uptime_days
from cte a
join cte b on a.server_id = b.server_id and a.rnk = b.rnk and a.session_status = 'start' and b.session_status = 'stop'


-- Python
import pandas as pd

def server_utilization_time(servers: pd.DataFrame) -> pd.DataFrame:
    servers = servers.sort_values(['server_id','status_time'])
    servers['stop_time'] = servers.groupby(['server_id']).status_time.shift(-1)
    # 这里相当于已经不管start还是stop了，因为我看数据发现会存在按照时间排序是：start start stop stop的情况
    servers = servers.query("session_status == 'start' and ~stop_time.isna()")
    servers['day'] = ((servers['stop_time'] - servers['status_time']).dt.total_seconds())/86400

    days = floor(servers.day.sum())

    return pd.DataFrame({'total_uptime_days':[days]})


-- 另外的做法：
import pandas as pd

def server_utilization_time(servers: pd.DataFrame) -> pd.DataFrame:
    servers['rnk'] = servers.groupby(['server_id','session_status']).status_time.rank()

    merge = pd.merge(servers,servers,on = ['server_id','rnk'])
    merge = merge[(merge['session_status_x'] == 'start') & (merge['session_status_y'] == 'stop')]
    merge['seconds_total'] = (merge['status_time_y'] - merge['status_time_x']).dt.total_seconds()
    
    total_uptime_days = floor(merge.seconds_total.sum()/(60 * 60 * 24))
    return pd.DataFrame({'total_uptime_days':[total_uptime_days]})