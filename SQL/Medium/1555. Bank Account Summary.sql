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
    