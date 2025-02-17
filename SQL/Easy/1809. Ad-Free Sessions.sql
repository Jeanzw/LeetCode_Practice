-- 这道题关键在于弄懂题目意思，也就是说我们要保证timestamp是在starttime和endtime之间的
select distinct session_id
FROM Playback p
left join Ads a on p.customer_id = a.customer_id and a.timestamp between p.start_time and p.end_time
where a.customer_id is null

------------------------------

-- Python
import pandas as pd
import numpy as np

def ad_free_sessions(playback: pd.DataFrame, ads: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(playback,ads,on = 'customer_id',how = 'left').fillna(0)
    merge['ad'] = np.where((merge['timestamp'] >= merge['start_time']) & (merge['timestamp'] <= merge['end_time']),1,0)
    res = merge.groupby(['session_id'],as_index = False).ad.sum()
    res = res.query('ad == 0')
    return res[['session_id']].drop_duplicates()



-- 另外的做法：
import pandas as pd

def ad_free_sessions(playback: pd.DataFrame, ads: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(playback,ads,on = 'customer_id', how = 'left')
    merge = merge[(merge['timestamp'] >= merge['start_time']) & (merge['timestamp'] <= merge['end_time'])][['session_id']].drop_duplicates()

    playback = playback[~playback['session_id'].isin(merge['session_id'])]
    return playback[['session_id']]