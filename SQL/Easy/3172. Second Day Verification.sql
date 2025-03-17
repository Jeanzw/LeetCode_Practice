select 
distinct a.user_id
from emails a
inner join texts b 
on a.email_id = b.email_id
and datediff(date(action_date),date(signup_date)) = 1
and signup_action = 'Verified'
order by 1

-----------------------

-- python
import pandas as pd

def find_second_day_signups(emails: pd.DataFrame, texts: pd.DataFrame) -> pd.DataFrame:
    # 先将两个日期数据进行处理
    emails['signup_date'] = emails['signup_date'].dt.strftime('%Y-%m-%d')
    emails['signup_date'] = pd.to_datetime(emails['signup_date'])
    texts['action_date'] = texts['action_date'].dt.strftime('%Y-%m-%d')
    texts['action_date'] = pd.to_datetime(texts['action_date'])
    # 然后再开始计算
    merge = pd.merge(emails,texts,on = 'email_id')
    merge['datediff'] = (merge['action_date'] - merge['signup_date']).dt.days
    merge = merge[(merge['signup_action'] == 'Verified') & (merge['datediff'] == 1)]
    return merge[['user_id']].sort_values('user_id')