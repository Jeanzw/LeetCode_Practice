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



import pandas as pd

def monthly_transactions(transactions: pd.DataFrame, chargebacks: pd.DataFrame) -> pd.DataFrame:
    # 先把transactions的日期进行处理
    transactions['month'] = transactions['trans_date'].dt.strftime('%Y-%m')
    # 找到approved的行，并且取出我想要的内容
    trans_approved = transactions.query("state == 'approved'")[
        ['id','country','state','amount','month']
    ]
    # 这里我们用as_index = False让month和country两列显现
    # 并且用agg()对两列进行aggregation
    trans_approved = trans_approved.groupby(['month','country'],as_index = False).agg(
        approved_count =('id','count'),
        approved_amount = ('amount','sum')
    )
    
    # 依旧是对chargeback这一个表进行日期处理
    chargebacks['month'] = chargebacks['trans_date'].dt.strftime('%Y-%m')
    # 和transactions连接，找到对应的钱和国家
    trans_chargeback = pd.merge(
        transactions,chargebacks, left_on = 'id', right_on = 'trans_id', how = 'inner'
        )[['id','country','amount','month_y']].rename(columns = {'month_y':'month'})
    
    # 对trans_chargeback进行求和处理,同时注意，这里依旧是要确保as_index = False
    trans_chargeback = trans_chargeback.groupby(['month','country'], as_index = False).agg(
        chargeback_count = ('id','count'),
        chargeback_amount = ('amount','sum')
    )


    res = trans_approved.merge(trans_chargeback, how = 'outer', on = ['month','country']).fillna(0)
    return res