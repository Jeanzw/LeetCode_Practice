with transaction_money as
(select id,sum(money) as money from
(select paid_by as id, - amount as money from Transactions
union all
 select paid_to as id, amount as money from Transactions
)tmp group by 1)

select 
    user_id,
    user_name,
    credit + ifnull(money,0) as credit,
    case when credit + ifnull(money,0) < 0 then 'Yes' else 'No' end as credit_limit_breached
    from Users u
    left join transaction_money t on u.user_id = t.id

---------------------------------------------

-- 也可以这样：
with cte as
(select 
u.user_id,
# user_name,
ifnull(sum(case when t.paid_by = u.user_id then -amount else amount end),0) as credit
from Users u
left join Transactions t on t.paid_by = u.user_id or t.paid_to = u.user_id
group by 1)

select
u.user_id,
u.user_name,
(u.credit + c.credit) as credit,
case when (u.credit + c.credit) >= 0 then 'No' else 'Yes' end as credit_limit_breached
from Users u
left join cte c on u.user_id = c.user_id

---------------------------------------------

-- Python
import pandas as pd
import numpy as np

def bank_account_summary(users: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:
    paid_by = transactions[['paid_by','amount']].rename(columns = {'paid_by':'user_id'})
    paid_by['amount'] = -paid_by['amount']
    paid_to = transactions[['paid_to','amount']].rename(columns = {'paid_to':'user_id'})

    concat = pd.concat([paid_by,paid_to]).groupby(['user_id'], as_index = False).amount.sum()

    merge = pd.merge(users,concat, on ='user_id', how = 'left').fillna(0)
    merge['credit'] = merge['credit'] + merge['amount']
    merge['credit_limit_breached'] = np.where(merge['credit'] >= 0, 'No','Yes')

    return merge[['user_id','user_name','credit','credit_limit_breached']]



-- 另外的做法
import pandas as pd
import numpy as np

def bank_account_summary(users: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(users,transactions,how = 'cross')
    merge = merge[(merge['user_id'] == merge['paid_by']) | (merge['user_id'] == merge['paid_to'])]
    merge['amount'] = np.where(merge['user_id'] == merge['paid_by'], -merge['amount'],merge['amount'])
    merge = merge.groupby(['user_id','user_name','credit'],as_index = False).amount.sum()

    res = pd.merge(users,merge, on = ['user_id', 'user_name','credit'], how = 'left').fillna(0)
    res['credit'] = res['credit'] + res['amount']
    res['credit_limit_breached'] = np.where(res['credit'] < 0,'Yes','No')

    return res[['user_id','user_name','credit','credit_limit_breached']]