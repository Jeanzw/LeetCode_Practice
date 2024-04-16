with recursive week_of_month as
(select 1 as week_of_month
union all
select week_of_month + 1 as week_of_month from week_of_month
where week_of_month< 4
)
, membership as
(select 'Premium' as membership
union all
select 'VIP' as membership
)
, framework as
(select * from week_of_month,membership)
, summary as
(select
a.user_id,
week(purchase_date) - week('2023-11-01') + 1 as week_of_month,
b.membership,
sum(amount_spend) as amount_spend
from Purchases a
left join Users b on a.user_id = b.user_id
where membership in ('Premium','VIP')
and weekday(purchase_date) = 4
group by 1,2,3
)

select
a.week_of_month,
a.membership,
ifnull(sum(amount_spend),0) as total_amount
from framework a
left join summary b on a.membership = b.membership and a.week_of_month = b.week_of_month
group by 1,2
order by 1,2