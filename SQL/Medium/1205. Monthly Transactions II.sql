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
amount from Transactions where state = 'approved'
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



