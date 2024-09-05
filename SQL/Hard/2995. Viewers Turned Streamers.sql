with rnk as
(select user_id, session_type, row_number() over (partition by user_id order by session_start) as rnk from Sessions)
, user as
(select user_id from rnk where rnk = 1 and session_type = 'Viewer')

select a.user_id, count(distinct session_id) as sessions_count
from Sessions a
inner join user b on a.user_id = b.user_id
where a.session_type = 'Streamer'
group by 1
order by 2 desc,1 desc

-- 直接来算不用join
# Write your MySQL query statement below
with cte as
(select
*,
rank() over (partition by user_id order by session_start) as rnk,
count(*) over (partition by user_id) as sessions_tt_count,
count(case when session_type = 'Streamer' then session_id end) over (partition by user_id) as sessions_count
from Sessions)

select 
    user_id, 
    sessions_count 
from cte 
where rnk = 1 and session_type = 'Viewer' and sessions_tt_count > 1
order by 2 desc, 1 desc


-- Python
import pandas as pd

def count_turned_streamers(sessions: pd.DataFrame) -> pd.DataFrame:
    sessions['rnk'] = sessions.groupby(['user_id']).session_start.rank()
    sessions['cnt_total'] = sessions.groupby(['user_id']).session_id.transform('nunique')
    # 第一个session是Viewer
    first_session_viewer = sessions.query("rnk == 1 and session_type == 'Viewer' and cnt_total > 1")
    # session_type是Streamer的计数
    streamer = sessions.query("session_type == 'Streamer'").groupby(['user_id'], as_index = False).session_id.nunique()
    # merge
    merge = pd.merge(first_session_viewer,streamer, on = 'user_id')
    return merge[['user_id','session_id_y']].rename(columns = {'session_id_y':'sessions_count'}).sort_values(['sessions_count','user_id'], ascending = [0,0])