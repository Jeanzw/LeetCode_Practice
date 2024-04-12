-- 这道题我还没看到有人不用自己算的时间来做的，但是我觉得按照自己算的时间来做其实是不对的
with recursive cte as
(select 1 as week_of_month,'2023-11-03' as purchase_date
union all
select week_of_month + 1 as week_of_month, purchase_date + interval '7' day as purchase_date from cte
where week_of_month < 4)



select a.week_of_month, a.purchase_date, ifnull(sum(amount_spend),0) as total_amount
from cte a
left join Purchases b on b.purchase_date = a.purchase_date
group by 1,2
order by 1