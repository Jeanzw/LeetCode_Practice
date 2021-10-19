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