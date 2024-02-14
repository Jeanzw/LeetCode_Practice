-- 这道题我一开始想不通到底是怎么算的，但实际上逻辑非常简单，就是各论各的
-- 我们的month其实是各论各的，如果一个id在1月份交易，但是2月份chargeback，那么交易放在一月份统计，而chargeback放在二月份统计






select month,country,
sum(case when type = 'approved' then 1 else 0 end) as approved_count,
sum(case when type = 'approved' then amount else 0 end) as approved_amount,
sum(case when type = 'chargeback' then 1 else 0 end) as chargeback_count,
sum(case when type = 'chargeback' then amount else 0 end) as chargeback_amount 
from 
(
(select date_format(trans_date,'%Y-%m') as month,  country,amount,'approved' as type from Transactions where state = 'approved')

union all

(select date_format(c.trans_date,'%Y-%m') as month, country,amount,'chargeback' as type from Transactions t join CHargebacks c on id = trans_id)
)tmp
group by month, country


-- 用cte应该会更加看起来简洁一点
with trans_charge as
(select 
date_format(trans_date,'%Y-%m') as month,
country,
state,
amount 
from Transactions where state = 'approved'

union all

select 
date_format(c.trans_date,'%Y-%m') as month,
country,
'chargeback' as state,
amount from Chargebacks c left join Transactions t on c.trans_id = t.id)
-- 由于我是既要看chargeback又要看transaction，那么我们只能说把这两者union all起来
-- 然后在下面用一个case when来处理和计算

select 
month,
country,
sum(case when state = 'approved' then 1 else 0 end) as approved_count,
sum(case when state = 'approved' then amount else 0 end) as approved_amount,
sum(case when state = 'chargeback' then 1 else 0 end) as chargeback_count,
sum(case when state = 'chargeback' then amount else 0 end) as chargeback_amount
from trans_charge
group by 1,2



-- 我对上面的解法进行修改，我还是倾向于用count来计数
with rawdata as
(select
date_format(trans_date,'%Y-%m') as month,
country,
state,
amount,
id
from Transactions
where state = 'approved'

union all

select
date_format(c.trans_date,'%Y-%m') as month,
country,
'chargeback' as state,
amount,
trans_id as id
from Chargebacks c
left join Transactions t on c.trans_id = t.id)


select 
month,
country,
count(distinct case when state = 'approved' then id end) as approved_count,
sum(case when state = 'approved' then amount else 0 end) as approved_amount,
count(distinct case when state = 'chargeback' then id end) as chargeback_count,
sum(case when state = 'chargeback' then amount else 0 end) as chargeback_amount
from rawdata
group by 1,2



-- Python
import pandas as pd
​
def monthly_transactions(transactions: pd.DataFrame, chargebacks: pd.DataFrame) -> pd.DataFrame:

    df = transactions.merge(chargebacks, left_on='id', right_on='trans_id', how='left')

    df['month_chargeback'] = df['trans_date_y'].dt.strftime('%Y-%m')

    df['month_transaction'] = df['trans_date_x'].dt.strftime('%Y-%m')

    df1 = df[df['state'] == 'approved'].groupby(
        ['month_transaction', 'country'], as_index=False
        ).agg(
            approved_count=('amount', 'count'),
            approved_amount=('amount', 'sum')
        ).rename(columns={'month_transaction': 'month'})

    df2 = df.groupby(
        ["month_chargeback", "country"], as_index=False
        ).agg(
            chargeback_count=('amount', 'count'), 
            chargeback_amount=('amount', 'sum')
        ).rename(columns={'month_chargeback': 'month'})
        
    df3 = df1.merge(df2, how='outer', on=['month', 'country']).fillna(0)

    return df3