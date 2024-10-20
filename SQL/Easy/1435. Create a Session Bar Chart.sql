with bin_bar as
(select "[0-5>" as bin
union all
select "[5-10>" as bin
union all
select  "[10-15>" as bin
union all
select  "15 or more"  as bin)
,
duration as
(select 
case when duration/60 between 0 and 5 then "[0-5>"
    when duration/60 between 5 and 10 then "[5-10>"
    when duration/60 between 10 and 15 then "[10-15>"
    else "15 or more" end as bin from Sessions)
    
select a.bin,count(b.bin) as total from bin_bar a
left join duration b on a.bin = b.bin
group by 1


-- Python
import pandas as pd
import numpy as np

def create_bar_chart(sessions: pd.DataFrame) -> pd.DataFrame:
    frame = pd.DataFrame({'bin':['[0-5>','[5-10>','[10-15>','15 or more']})
    sessions['bin'] = np.where(sessions['duration']/60 < 5, '[0-5>',
                      np.where(sessions['duration']/60 < 10, '[5-10>',
                      np.where(sessions['duration']/60 < 15,'[10-15>','15 or more')))

    summary = pd.merge(frame,sessions, on = 'bin', how = 'left').groupby(['bin'],as_index = False).session_id.nunique()
    return summary.rename(columns = {'session_id':'total'})