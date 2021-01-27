select 
round(100* sum(case when order_date = customer_pref_delivery_date then 1.0 else 0 end)
/
count(distinct customer_id), 2) as immediate_percentage
from
(select *, rank() over (partition by customer_id order by order_date) as rnk from Delivery)tmp
where rnk = 1



-- 我之后做就不太愿意用rank了 
-- 而是直接用customerid和order date来做ding wei le
select 
    round(100 * sum(case when order_date = customer_pref_delivery_date then 1 else 0 end)
    /count(*),2) as immediate_percentage
    from Delivery
    where (customer_id,order_date) in
    (select customer_id,min(order_date) as first_order_date from Delivery 
    group by 1)