select extra as report_reason,count(distinct post_id) as report_count from Actions 
where action  = 'report' 
and action_date = '2019-07-05' - interval '1' day
-- and datediff('2019-07-05',action_date) <= 1
group by 1

-- Python
import pandas as pd

def reported_posts(actions: pd.DataFrame) -> pd.DataFrame:
    actions = actions.query("action_date == '2019-07-04' and action == 'report'")
    actions = actions.groupby(['extra'],as_index = False).post_id.nunique()
    return actions.rename(columns = {'extra':'report_reason','post_id':'report_count'})