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


-- Python
import pandas as pd

def server_utilization_time(servers: pd.DataFrame) -> pd.DataFrame:
    servers = servers.sort_values(['server_id','status_time'])
    servers['stop_time'] = servers.groupby(['server_id']).status_time.shift(-1)
    servers = servers.query("session_status == 'start' and ~stop_time.isna()")
    servers['day'] = ((servers['stop_time'] - servers['status_time']).dt.total_seconds())/86400

    days = floor(servers.day.sum())

    return pd.DataFrame({'total_uptime_days':[days]})