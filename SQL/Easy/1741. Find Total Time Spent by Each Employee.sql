select event_day as day,
emp_id,
sum(out_time - in_time) as total_time
from Employees
group by 1,2

------------------------------------------

-- Python
import pandas as pd

def total_time(employees: pd.DataFrame) -> pd.DataFrame:
    employees['time'] = employees['out_time'] - employees['in_time']
    res = employees.groupby(['event_day','emp_id'], as_index = False).time.sum()
    return res.rename(columns = {'event_day':'day','time':'total_time'})