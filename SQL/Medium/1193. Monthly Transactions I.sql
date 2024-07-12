select 
    date_format(trans_date,'%Y-%m') as month,
    country, 
    count(*) as trans_count,
    sum(case when state = 'approved' then 1 else 0 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state = 'approved' then amount else 0 end) as approved_total_amount

from Transactions
group by month, country

-- 其实我个人还是会习惯在计数的时候不用1和0来计数，因为我们并不知道是否会有重复值
-- 所以我个人目前更倾向于还是保留id这个选项来进行计数
select
    date_format(trans_date,'%Y-%m') as month,
    country,
    count(distinct id) as trans_count,
    count(distinct case when state = 'approved' then id else null end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
    from Transactions
    group by 1,2



-- Python
import pandas as pd
import numpy as np

def monthly_transactions(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['month'] = transactions['trans_date'].dt.strftime('%Y-%m')
    # 如果没有下一列将原本的null值改成“null”，那么我们计算的时候就会把null值的那一行直接去除
    transactions['country'].fillna('null',inplace=True)
    transactions['approved'] = np.where(transactions['state'] == 'approved',transactions['amount'],nan)
    transactions = transactions.groupby(['month','country'],as_index = False).agg(
        trans_count = ('amount','count'),
        approved_count = ('approved','count'),
        trans_total_amount = ('amount','sum'),
        approved_total_amount = ('approved','sum')
    )
    # 因为之前把null变成了“null”，但是我们最后结果还是想要的是null，所以就用replace把属于“null”的值赋值null
    transactions['country'] = np.where(transactions['country'] == 'null',nan,transactions['country'])
    return transactions