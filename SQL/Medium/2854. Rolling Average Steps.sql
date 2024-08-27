select
a.user_id,
a.steps_date,
round((a.steps_count + b.steps_count + c.steps_count)/3,2) as rolling_average
from Steps a
inner join Steps b on a.user_id = b.user_id and datediff(a.steps_date,b.steps_date) = 1
inner join Steps c on b.user_id = c.user_id and datediff(b.steps_date,c.steps_date) = 1
order by 1,2


-- Python
import pandas as pd

def rolling_average(steps: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(steps,steps,on = 'user_id').merge(steps,on = 'user_id')
    merge['diff1'] = (merge['steps_date_x'] - merge['steps_date_y']).dt.days
    merge['diff2'] = (merge['steps_date_y'] - merge['steps_date']).dt.days
    merge = merge.query("diff1 == 1 and diff2 == 1")
    merge['rolling_average'] = round((merge['steps_count_x'] + merge['steps_count_y'] + merge['steps_count'])/3,2)
    return merge[['user_id','steps_date_x','rolling_average']].rename(columns = {'steps_date_x':'steps_date'}).sort_values(['user_id','steps_date'])