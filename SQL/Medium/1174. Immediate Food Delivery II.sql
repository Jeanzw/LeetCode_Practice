select 
round(100* sum(case when order_date = customer_pref_delivery_date then 1.0 else 0 end)
/
count(distinct customer_id), 2) as immediate_percentage
from
(select *, rank() over (partition by customer_id order by order_date) as rnk from Delivery)tmp
where rnk = 1



-- 我之后做就不太愿意用rank了 
-- 而是直接用customerid和order date来做定位了
select 
    round(100 * sum(case when order_date = customer_pref_delivery_date then 1 else 0 end)
    /count(*),2) as immediate_percentage
    from Delivery
    where (customer_id,order_date) in
    (select customer_id,min(order_date) as first_order_date from Delivery 
    group by 1)

-- 其实我个人并不推荐用sum来计数，因为就是可能存在表出问题的情况（虽然在面试中可能不存在这样的情况）
select
round(100 * count(distinct case when order_date = customer_pref_delivery_date then delivery_id else null end)
/
count(distinct delivery_id),2) as immediate_percentage
from Delivery
where (customer_id , order_date) in (select customer_id, min(order_date) from Delivery group by 1)



-- Python
import pandas as pd

def immediate_food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    delivery['rnk'] = delivery.groupby(['customer_id']).order_date.transform('rank', method = 'first')
    delivery = delivery.query("rnk == 1")
    n = delivery.query("order_date == customer_pref_delivery_date").customer_id.nunique()
    d = delivery.customer_id.nunique()
    return pd.DataFrame({'immediate_percentage':[round(100 * n/d,2)]})