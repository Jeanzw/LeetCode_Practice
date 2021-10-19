select customer_id,count(*) as count_no_trans from Visits
where visit_id not in
(select visit_id from Transactions)
group by 1


-- 我们还可以就直接用join来做，这样效率高一点
select
customer_id,
count(distinct v.visit_id) as count_no_trans
from Visits v
left join Transactions t on v.visit_id = t.visit_id
where t.visit_id is null
group by 1