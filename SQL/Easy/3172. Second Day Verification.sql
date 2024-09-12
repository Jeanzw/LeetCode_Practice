select 
distinct a.user_id
from emails a
inner join texts b 
on a.email_id = b.email_id
and datediff(date(action_date),date(signup_date)) = 1
and signup_action = 'Verified'
order by 1


-- python
import pandas as pd

def find_second_day_signups(emails: pd.DataFrame, texts: pd.DataFrame) -> pd.DataFrame:
    emails['signup_date'] = emails['signup_date'].dt.strftime('%Y-%m-%d')
    texts['action_date'] = texts['action_date'].dt.strftime('%Y-%m-%d')
    
    merge = pd.merge(emails,texts,on = 'email_id')
    merge['diff'] = (pd.to_datetime(merge['action_date']) - pd.to_datetime(merge['signup_date'])).dt.days
    merge = merge.query("signup_action == 'Verified' and diff == 1")
    return merge[['user_id']].sort_values('user_id') 