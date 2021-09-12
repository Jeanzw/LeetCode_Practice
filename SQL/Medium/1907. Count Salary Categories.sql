with frame as
(select 'Low Salary' as category
union 
 select 'Average Salary' as category
union
select 'High Salary' as category
)
, cal as
(select
case when income < 20000 then 'Low Salary' 
    when income >= 20000 and income <= 50000 then 'Average Salary'
    else 'High Salary' end as category,
    count(distinct account_id) as accounts_count 
    from Accounts 
    group by 1)
    

select f.category, ifnull(accounts_count,0) as accounts_count
from frame f
left join cal c on f.category = c.category


-- 或者我们直接用union all来做也行
-- 也就是说将account这张表分别拆成几个income类别的，然后各类别进行union all
select "Low Salary" as category,
sum(case when income<20000 then 1 else 0 end) as accounts_count
from Accounts

union

select "Average Salary" category,
sum(case when income >= 20000 and income <= 50000 then 1 else 0 end) as accounts_count
from Accounts

union

select "High Salary" category,
sum(case when income>50000 then 1 else 0 end) as accounts_count
from Accounts