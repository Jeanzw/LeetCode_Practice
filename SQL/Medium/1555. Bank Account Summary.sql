with trans as
(select id,sum(num) as total from
(select paid_by as id, -amount as num from Transactions
union all
select paid_to as id, amount as num from Transactions)tmp
group by 1)

# select * from trans
select 
user_id,
user_name,
sum(credit + ifnull(total,0)) as credit,
case when sum(credit + total) <0 then "Yes" else "No" end as credit_limit_breached
from Users u
left join trans t on u.user_id = t.id
group by 1,2