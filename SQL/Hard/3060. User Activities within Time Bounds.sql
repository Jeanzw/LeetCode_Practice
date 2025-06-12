with summary as
(select
*, row_number() over (partition by user_id order by session_start) as rnk from Sessions)

select 
distinct a.user_id
from summary a
inner join summary b 
on a.user_id = b.user_id 
and a.session_type = b.session_type 
and a.rnk < b.rnk 
-- 这道题主要在于理解题目，最开始的时候我这里的condition是a.rnk + 1 = b.rnk
-- 但是题目的意思是，在12小时内出现连续的Viewer或者Streamer
-- 那么就可能存在viewer ->  streamer -> viewer但是两个viewer是在12小时内的
and timestampdiff(hour,a.session_end,b.session_start) <= 12
order by 1

---------------------------

-- 我们也可以不用row_number去确认出场顺序
-- 我们可能存在一个情况就是下一个session_start是在上一个session_end之后开始的
-- 也可能有一个情况是session_start是在上一个session_start和session_end之间开始的
-- 所以我们的timestampdiff是有两种情况
select
distinct a.user_id
from Sessions a
join Sessions b 
on a.user_id = b.user_id 
and a.session_type = b.session_type 
and a.session_id != b.session_id 
and ((timestampdiff(hour, a.session_start,b.session_start) between 0 and 12) 
    or (timestampdiff(hour, a.session_end,b.session_start) between 0 and 12))
order by 1

---------------------------

-- Python
import pandas as pd

def user_activities(sessions: pd.DataFrame) -> pd.DataFrame:
    sessions['rnk'] = sessions.groupby(['user_id']).session_start.rank()

    merge = pd.merge(sessions,sessions,on = ['user_id','session_type'])
    merge = merge[(merge['rnk_x'] < merge['rnk_y']) & ((merge['session_start_y'] - merge['session_end_x']).dt.total_seconds() <= 12 * 60 * 60) ]

    return merge[['user_id']].drop_duplicates().sort_values('user_id')

---------------------------

-- 或者就按照第二种sql的解法
import pandas as pd

def user_activities(sessions: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(sessions,sessions,on = ['user_id','session_type'])
    merge['hour_diff1'] = (merge['session_start_y'] - merge['session_end_x']).dt.total_seconds()
    merge['hour_diff2'] = (merge['session_start_y'] - merge['session_start_x']).dt.total_seconds()
    
    merge = merge[((merge['hour_diff1'] >= 0) & (merge['hour_diff1'] <= 12 * 60 * 60)) | ((merge['hour_diff2'] >= 0) & (merge['hour_diff2'] <= 12 * 60 * 60)) & (merge['session_id_x'] != merge['session_id_y'])]
    return merge[['user_id']].drop_duplicates().sort_values('user_id')